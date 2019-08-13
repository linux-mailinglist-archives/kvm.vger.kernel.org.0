Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 065CE8B2C1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfHMIod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:44:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36562 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfHMIoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:44:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so13234727wrt.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 01:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=blKE7hBPEaF3XcD8274I5hmyBZ0ZERzbpulCfit8yl4=;
        b=fw+BUVmVAOa37fDeyLWpYVWNQHXKuWXjKW5ZkXX2m8ab+rGgCkZYqLemhLBODraLsT
         fScyO9Op+/YYKfG2HojD1BzASZZQzIv/I/d3yIKWNjtv+ie6YWRlq0Mr9D0XxWowH77P
         8UAr/qM+eAuOzHMWxpL7LxJnY7BtHAAFZqqTHLL7xxUTeS3EVm+KlKghMiVx2Pf+A9tr
         xa2+NrCFclpQ/6Ou0pCRpGyAjYqg4YymHDGhWS6OOn4AfZ+uf7h9lmMKaiIUzVZOXoFS
         J8ObzGaXos7dPC+hxvy27GnJ7MYRl5IIP6u1T1fljuqI3helV7+TLOizv/dJWP4ZSeXM
         podg==
X-Gm-Message-State: APjAAAWWbWVuQku+qkZ8Y71Sde0GXWWepMzG9rKamdLPA3Tcq2xf0YEY
        L94G9OjAfBfyENdrY1PBlVsBjQ==
X-Google-Smtp-Source: APXvYqw492WjaEpNzhoTXs/Gd2KelQnitfzJEsecNo1teLr2zcjaHoX7vjpPsoanUMoKR8v6ysgEKw==
X-Received: by 2002:a5d:490a:: with SMTP id x10mr42031164wrq.152.1565685870989;
        Tue, 13 Aug 2019 01:44:30 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o126sm1401625wmo.1.2019.08.13.01.44.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:44:30 -0700 (PDT)
Subject: Re: [RFC PATCH v6 02/92] kvm: introspection: add basic ioctls
 (hook/unhook)
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-3-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <58808ef0-57b1-47ac-a115-e1dd64a15b0a@redhat.com>
Date:   Tue, 13 Aug 2019 10:44:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-3-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> +static int kvmi_recv(void *arg)
> +{
> +	struct kvmi *ikvm = arg;
> +
> +	kvmi_info(ikvm, "Hooking VM\n");
> +
> +	while (kvmi_msg_process(ikvm))
> +		;
> +
> +	kvmi_info(ikvm, "Unhooking VM\n");
> +
> +	kvmi_end_introspection(ikvm);
> +
> +	return 0;
> +}
> +

Rename this to kvmi_recv_thread instead, please.

> +
> +	/*
> +	 * Make sure all the KVM/KVMI structures are linked and no pointer
> +	 * is read as NULL after the reference count has been set.
> +	 */
> +	smp_mb__before_atomic();

This is an smp_wmb(), not an smp_mb__before_atomic().  Add a comment
that it pairs with the refcount_inc_not_zero in kvmi_get.

> +	refcount_set(&kvm->kvmi_ref, 1);
> +


> @@ -57,8 +183,27 @@ void kvmi_destroy_vm(struct kvm *kvm)
>  	if (!ikvm)
>  		return;
>  
> +	/* trigger socket shutdown - kvmi_recv() will start shutdown process */
> +	kvmi_sock_shutdown(ikvm);
> +
>  	kvmi_put(kvm);
>  
>  	/* wait for introspection resources to be released */
>  	wait_for_completion_killable(&kvm->kvmi_completed);
>  }
> +

This addition means that kvmi_destroy_vm should have called
kvmi_end_introspection instead.  In patch 1, kvmi_end_introspection
should have been just kvmi_put, now this patch can add kvmi_sock_shutdown.

Paolo
