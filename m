Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E1E2E7880
	for <lists+kvm@lfdr.de>; Wed, 30 Dec 2020 13:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgL3MZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 07:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgL3MY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 07:24:59 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E712EC061799
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 04:24:18 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id o19so37341414lfo.1
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 04:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=BRP5DDNoocjmFRMP04L1ocx/vXAdWsGfsSaJN6mdwH8=;
        b=FPZUFpmEUDFxV1hf5jQg7f5+3LhJS4EKzpM/LFvL5Pgo9IXqfqzE39BNMNCQwh6WAg
         oCG7tQWxhPGHQPNIf+n4jq90gJG8+X7WtVhznUYrey3Aww9BJwVeAQLK7/AZ6u4XIllb
         GsFd6/cXJ/Ml1eWP7ejk91T4alrbM+cXgIXWkW60DDEXf6iUcPEIQNyIAw4spO2FjHHg
         5DknHtD2cPfYG3MRq8RZlvfln2LuhddzMfAq6hIwILhtZ+Nva7BKBxXDnbUDlHSEjSTF
         yOMMxDrpLjCHChkhpL2s9RpoFjroZSVmBHGgpO8rQPv3NSkD3PQ4hC+zJG4f02K/TFip
         KK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BRP5DDNoocjmFRMP04L1ocx/vXAdWsGfsSaJN6mdwH8=;
        b=CgS6zPGmHOaMbn+zVTxe2XfqNCpgbPWZmoTCsGZqXW0dPoikwBFhrcA7U3/U3lncQu
         7plyu/wXP8DguqVUplF63pmha/InnaYMQ9utJ2b6shRgWwGubH9ucynD8P3T1Ep27/kI
         d91C2iD14NHKrvDI4lMaUB8JAYpAKDIw7Q0iihrYHArE9ywHOokJxZwg1JG7VTCovy1U
         mhxjRZl/4pXYT4xERNk5OCKh2IxaV7F88evr9PM9AysKJRRNHUeRXMQdoU+AqLJkcvGK
         pcB2HvXp2lNjQ//tUFcypNGDpkL9xQ5PQlP0QYHV+aW+S2Wi37dRZF0UtFHwtTFTDpFA
         4ocA==
X-Gm-Message-State: AOAM532e+LKR+5kECXLsiJPJ+HitmOWuq2Kn+Z3697j+pfbrQTj29ni3
        jmMluq/ttIAkOE+9NE4i21MFNn7ywrohEQ==
X-Google-Smtp-Source: ABdhPJwLxVmOCehPB+Uke4yPxdzE+4dkt/iak9vr1rgKOrBJrSFz2k9cmRK6e9s1YqWF1ucf8KjV1A==
X-Received: by 2002:a05:6512:64:: with SMTP id i4mr21139041lfo.95.1609331057398;
        Wed, 30 Dec 2020 04:24:17 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id t4sm5979173lff.260.2020.12.30.04.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 04:24:16 -0800 (PST)
Message-ID: <3250c72b172f0659e6ecb910d595c94f4689a021.camel@gmail.com>
Subject: Re: [RFC 2/2] KVM: add initial support for ioregionfd blocking
 read/write operations
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Wed, 30 Dec 2020 04:24:06 -0800
In-Reply-To: <20201229120023.GC55616@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
         <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
         <20201229120023.GC55616@stefanha-x1.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-29 at 12:00 +0000, Stefan Hajnoczi wrote:
> On Tue, Dec 29, 2020 at 01:02:44PM +0300, Elena Afanasova wrote:
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> >  virt/kvm/ioregion.c | 157
> > ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 157 insertions(+)
> > 
> > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > index a200c3761343..8523f4126337 100644
> > --- a/virt/kvm/ioregion.c
> > +++ b/virt/kvm/ioregion.c
> > @@ -4,6 +4,33 @@
> >  #include <kvm/iodev.h>
> >  #include "eventfd.h"
> >  
> > +/* Wire protocol */
> > +struct ioregionfd_cmd {
> > +	__u32 info;
> > +	__u32 padding;
> > +	__u64 user_data;
> > +	__u64 offset;
> > +	__u64 data;
> > +};
> > +
> > +struct ioregionfd_resp {
> > +	__u64 data;
> > +	__u8 pad[24];
> > +};
> > +
> > +#define IOREGIONFD_CMD_READ    0
> > +#define IOREGIONFD_CMD_WRITE   1
> > +
> > +#define IOREGIONFD_SIZE_8BIT   0
> > +#define IOREGIONFD_SIZE_16BIT  1
> > +#define IOREGIONFD_SIZE_32BIT  2
> > +#define IOREGIONFD_SIZE_64BIT  3
> > +
> > +#define IOREGIONFD_SIZE_OFFSET 4
> > +#define IOREGIONFD_RESP_OFFSET 6
> > +#define IOREGIONFD_SIZE(x) ((x) << IOREGIONFD_SIZE_OFFSET)
> > +#define IOREGIONFD_RESP(x) ((x) << IOREGIONFD_RESP_OFFSET)
> 
> These belong in the uapi header so userspace also has struct
> ioregionfd_cmd, struct ioregionfd_resp, etc.
> 
I'll move the wire protocol to a separate uapi header

> > +
> >  void
> >  kvm_ioregionfd_init(struct kvm *kvm)
> >  {
> > @@ -38,10 +65,100 @@ ioregion_release(struct ioregion *p)
> >  	kfree(p);
> >  }
> >  
> > +static bool
> > +pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, int opt,
> > bool resp,
> > +	 u64 user_data, const void *val)
> > +{
> > +	u64 size = 0;
> > +
> > +	switch (len) {
> > +	case 1:
> > +		size = IOREGIONFD_SIZE_8BIT;
> > +		*((u8 *)&cmd->data) = val ? *(u8 *)val : 0;
> > +		break;
> > +	case 2:
> > +		size = IOREGIONFD_SIZE_16BIT;
> > +		*((u16 *)&cmd->data) = val ? *(u16 *)val : 0;
> > +		break;
> > +	case 4:
> > +		size = IOREGIONFD_SIZE_32BIT;
> > +		*((u32 *)&cmd->data) = val ? *(u32 *)val : 0;
> > +		break;
> > +	case 8:
> > +		size = IOREGIONFD_SIZE_64BIT;
> > +		*((u64 *)&cmd->data) = val ? *(u64 *)val : 0;
> > +		break;
> > +	default:
> > +		return false;
> > 
> 
> The assignments and casts can be replaced with a single memcpy after
> the
> switch statement. This is also how KVM_EXIT_MMIO and Coalesced MMIO
> do
> it:
> 
>   memcpy(cmd->data, val, len);
> 
Thanks for pointing it out

> However, we need to make sure that cmd has been zeroed so that kernel
> memory is not accidentally exposed to userspace.
> 
>  +	}
> > +	cmd->user_data = user_data;
> > +	cmd->offset = offset;
> > +	cmd->info |= opt;
> > +	cmd->info |= IOREGIONFD_SIZE(size);
> > +	cmd->info |= IOREGIONFD_RESP(resp);
> > +
> > +	return true;
> > +}
> > +
> >  static int
> >  ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> > gpa_t addr,
> >  	      int len, void *val)
> >  {
> > +	struct ioregion *p = to_ioregion(this);
> > +	struct ioregionfd_cmd *cmd;
> > +	struct ioregionfd_resp *resp;
> > +	size_t buf_size;
> > +	void *buf;
> > +	int ret = 0;
> > +
> > +	if ((p->rf->f_flags & O_NONBLOCK) || (p->wf->f_flags &
> > O_NONBLOCK))
> > +		return -EINVAL;
> 
> Another CPU could change file descriptor flags while we are running.
> Therefore it might be simplest to handle kernel_write() and
> kernel_read() -EAGAIN return values instead of trying to check.
> 
Ok, I'll fix this

> > +	if ((addr + len - 1) > (p->paddr + p->size - 1))
> > +		return -EINVAL;
> > +
> > +	buf_size = max_t(size_t, sizeof(*cmd), sizeof(*resp));
> > +	buf = kzalloc(buf_size, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +	cmd = (struct ioregionfd_cmd *)buf;
> > +	resp = (struct ioregionfd_resp *)buf;
> 
> I think they are small enough to declare them on the stack:
> 
>   union {
>       struct ioregionfd_cmd cmd;
>       struct ioregionfd_resp resp;
>   } buf;
> 
>   memset(&buf, 0, sizeof(buf));
> 
Ok

> > +	if (!pack_cmd(cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
> > +		      1, p->user_data, NULL)) {
> > +		kfree(buf);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	ret = kernel_write(p->wf, cmd, sizeof(*cmd), 0);
> > +	if (ret != sizeof(*cmd)) {
> > +		kfree(buf);
> > +		return (ret < 0) ? ret : -EIO;
> > +	}
> > +	memset(buf, 0, buf_size);
> > +	ret = kernel_read(p->rf, resp, sizeof(*resp), 0);
> > +	if (ret != sizeof(*resp)) {
> > +		kfree(buf);
> > +		return (ret < 0) ? ret : -EIO;
> > +	}
> > +
> > +	switch (len) {
> > +	case 1:
> > +		*(u8 *)val = (u8)resp->data;
> > +		break;
> > +	case 2:
> > +		*(u16 *)val = (u16)resp->data;
> > +		break;
> > +	case 4:
> > +		*(u32 *)val = (u32)resp->data;
> > +		break;
> > +	case 8:
> > +		*(u64 *)val = (u64)resp->data;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> 
> This looks inconsistent. cmd->data is treated as a packed
> u8/u16/u32/864
> whereas resp->data is treated as u64?
> 
> I was expecting memcpy(val, &resp->data, len) here not the u64 ->
> u8/u16/u32/u64 conversion.
I'll fix this, thanks!


