Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204CE331F17
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhCIGUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:20:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCIGTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 01:19:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615270795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/i1pOCZnB0sU+RMAhWm4rW+GdEeRyO+LPBCxy6iwVc=;
        b=HjZgesXcFDA3NpC2fzMIZJdgEvAjclFp/EJolVO/Q9kHOtIeW3bZ41QQEW0ZfntNZvW5NI
        v9zgjVq2c56pTI0J4pJvTdHF8IP4X7o1kaJ2tXMNtintUzv8/5EAHoQOUX1j8BImS3UnHb
        iJawc1yIDoykE1XxFXoRP2/1tablCq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-ARZNWg2rP-mpxf5j_h3XSQ-1; Tue, 09 Mar 2021 01:19:52 -0500
X-MC-Unique: ARZNWg2rP-mpxf5j_h3XSQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41BB3801814;
        Tue,  9 Mar 2021 06:19:51 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-195.pek2.redhat.com [10.72.12.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D9985D6D7;
        Tue,  9 Mar 2021 06:19:41 +0000 (UTC)
Subject: Re: [RFC v3 3/5] KVM: implement wire protocol
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f9b5c5cf-63a4-d085-8c99-8d03d29d3f58@redhat.com>
Date:   Tue, 9 Mar 2021 14:19:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/21 8:04 下午, Elena Afanasova wrote:
> Add ioregionfd blocking read/write operations.
>
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> v3:
>   - change wire protocol license
>   - remove ioregionfd_cmd info and drop appropriate macros
>   - fix ioregionfd state machine
>   - add sizeless ioregions support
>   - drop redundant check in ioregion_read/write()
>
>   include/uapi/linux/ioregion.h |  30 +++++++
>   virt/kvm/ioregion.c           | 162 +++++++++++++++++++++++++++++++++-
>   2 files changed, 190 insertions(+), 2 deletions(-)
>   create mode 100644 include/uapi/linux/ioregion.h
>
> diff --git a/include/uapi/linux/ioregion.h b/include/uapi/linux/ioregion.h
> new file mode 100644
> index 000000000000..58f9b5ba6186
> --- /dev/null
> +++ b/include/uapi/linux/ioregion.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
> +#ifndef _UAPI_LINUX_IOREGION_H
> +#define _UAPI_LINUX_IOREGION_H
> +
> +/* Wire protocol */
> +
> +struct ioregionfd_cmd {
> +	__u8 cmd;
> +	__u8 size_exponent : 4;
> +	__u8 resp : 1;
> +	__u8 padding[6];
> +	__u64 user_data;
> +	__u64 offset;
> +	__u64 data;
> +};


Sorry if I've asked this before. Do we need a id for each 
request/response? E.g an ioregion fd could be used by multiple vCPUS. 
VCPU needs to have a way to find which request belongs to itself or not?


> +
> +struct ioregionfd_resp {
> +	__u64 data;
> +	__u8 pad[24];
> +};
> +
> +#define IOREGIONFD_CMD_READ    0
> +#define IOREGIONFD_CMD_WRITE   1
> +
> +#define IOREGIONFD_SIZE_8BIT   0
> +#define IOREGIONFD_SIZE_16BIT  1
> +#define IOREGIONFD_SIZE_32BIT  2
> +#define IOREGIONFD_SIZE_64BIT  3
> +
> +#endif
> diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> index e09ef3e2c9d7..1e1c7772d274 100644
> --- a/virt/kvm/ioregion.c
> +++ b/virt/kvm/ioregion.c
> @@ -3,6 +3,7 @@
>   #include <linux/fs.h>
>   #include <kvm/iodev.h>
>   #include "eventfd.h"
> +#include <uapi/linux/ioregion.h>
>   
>   void
>   kvm_ioregionfd_init(struct kvm *kvm)
> @@ -40,18 +41,175 @@ ioregion_release(struct ioregion *p)
>   	kfree(p);
>   }
>   
> +static bool
> +pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, u8 opt, u8 resp,
> +	 u64 user_data, const void *val)
> +{
> +	switch (len) {
> +	case 0:
> +		break;
> +	case 1:
> +		cmd->size_exponent = IOREGIONFD_SIZE_8BIT;
> +		break;
> +	case 2:
> +		cmd->size_exponent = IOREGIONFD_SIZE_16BIT;
> +		break;
> +	case 4:
> +		cmd->size_exponent = IOREGIONFD_SIZE_32BIT;
> +		break;
> +	case 8:
> +		cmd->size_exponent = IOREGIONFD_SIZE_64BIT;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	if (val)
> +		memcpy(&cmd->data, val, len);
> +	cmd->user_data = user_data;
> +	cmd->offset = offset;
> +	cmd->cmd = opt;
> +	cmd->resp = resp;
> +
> +	return true;
> +}
> +
> +enum {
> +	SEND_CMD,
> +	GET_REPLY,
> +	COMPLETE
> +};
> +
> +static void
> +ioregion_save_ctx(struct kvm_vcpu *vcpu, bool in, gpa_t addr, u8 state, void *val)
> +{
> +	vcpu->ioregion_ctx.is_interrupted = true;
> +	vcpu->ioregion_ctx.val = val;
> +	vcpu->ioregion_ctx.state = state;
> +	vcpu->ioregion_ctx.addr = addr;
> +	vcpu->ioregion_ctx.in = in;
> +}
> +
>   static int
>   ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   	      int len, void *val)
>   {
> -	return -EOPNOTSUPP;
> +	struct ioregion *p = to_ioregion(this);
> +	union {
> +		struct ioregionfd_cmd cmd;
> +		struct ioregionfd_resp resp;
> +	} buf;
> +	int ret = 0;
> +	int state = SEND_CMD;
> +
> +	if (unlikely(vcpu->ioregion_ctx.is_interrupted)) {
> +		vcpu->ioregion_ctx.is_interrupted = false;
> +
> +		switch (vcpu->ioregion_ctx.state) {
> +		case SEND_CMD:
> +			goto send_cmd;
> +		case GET_REPLY:
> +			goto get_repl;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +send_cmd:
> +	memset(&buf, 0, sizeof(buf));
> +	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
> +		      1, p->user_data, NULL))
> +		return -EOPNOTSUPP;
> +
> +	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
> +	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
> +	if (signal_pending(current) && state == SEND_CMD) {


Can the signal be delivered after a success of kernel_write()? If yes, 
is there any side effect if we want to redo the write here?


> +		ioregion_save_ctx(vcpu, 1, addr, state, val);
> +		return -EINTR;
> +	}
> +	if (ret != sizeof(buf.cmd)) {
> +		ret = (ret < 0) ? ret : -EIO;
> +		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +	}
> +	if (!p->rf)
> +		return 0;
> +
> +get_repl:
> +	memset(&buf, 0, sizeof(buf));
> +	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
> +	state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
> +	if (signal_pending(current) && state == GET_REPLY) {
> +		ioregion_save_ctx(vcpu, 1, addr, state, val);
> +		return -EINTR;
> +	}
> +	if (ret != sizeof(buf.resp)) {
> +		ret = (ret < 0) ? ret : -EIO;
> +		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +	}


We may need to unify the duplicated codes here with send_cmd.


> +
> +	memcpy(val, &buf.resp.data, len);
> +
> +	return 0;
>   }
>   
>   static int
>   ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>   		int len, const void *val)
>   {
> -	return -EOPNOTSUPP;
> +	struct ioregion *p = to_ioregion(this);
> +	union {
> +		struct ioregionfd_cmd cmd;
> +		struct ioregionfd_resp resp;
> +	} buf;
> +	int ret = 0;
> +	int state = SEND_CMD;
> +
> +	if (unlikely(vcpu->ioregion_ctx.is_interrupted)) {
> +		vcpu->ioregion_ctx.is_interrupted = false;
> +
> +		switch (vcpu->ioregion_ctx.state) {
> +		case SEND_CMD:
> +			goto send_cmd;
> +		case GET_REPLY:
> +			goto get_repl;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +send_cmd:
> +	memset(&buf, 0, sizeof(buf));
> +	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_WRITE,
> +		      p->posted_writes ? 0 : 1, p->user_data, val))
> +		return -EOPNOTSUPP;
> +
> +	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
> +	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
> +	if (signal_pending(current) && state == SEND_CMD) {
> +		ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
> +		return -EINTR;
> +	}
> +	if (ret != sizeof(buf.cmd)) {
> +		ret = (ret < 0) ? ret : -EIO;
> +		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +	}
> +
> +get_repl:
> +	if (!p->posted_writes) {
> +		memset(&buf, 0, sizeof(buf));
> +		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
> +		state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
> +		if (signal_pending(current) && state == GET_REPLY) {
> +			ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
> +			return -EINTR;
> +		}
> +		if (ret != sizeof(buf.resp)) {
> +			ret = (ret < 0) ? ret : -EIO;
> +			return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
> +		}
> +	}
> +
> +	return 0;


It looks to me we had more chance to unify the code with ioregion_read().

Thanks


>   }
>   
>   /*

