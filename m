Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01DD4D31EA
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 16:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiCIPlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 10:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbiCIPlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 10:41:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7E56119F06
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 07:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646840407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mf8CVJpykjONlYIj4F2lxLtCErMCmabEpV4EdOBokJ8=;
        b=V5q+KcS8ZvMg+7mKSoNFF11DRgjRJzKNlta1UiSBQSOVYplKhUy/0YpVUt3FrgDgR0fGVU
        Fmyrc3pNn7ksiaaYcWqADVdCbfNX81nIYD4Xkq7M1T9n+0p7MS02S6VrN0aExBb5Zg7SCb
        O6hy1QHeI1C4xYkuCEgqsIWyNMg3NkI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-y8qRDL3MN3KMl3_aiZHBPA-1; Wed, 09 Mar 2022 10:40:06 -0500
X-MC-Unique: y8qRDL3MN3KMl3_aiZHBPA-1
Received: by mail-ed1-f72.google.com with SMTP id l24-20020a056402231800b00410f19a3103so1485771eda.5
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 07:40:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mf8CVJpykjONlYIj4F2lxLtCErMCmabEpV4EdOBokJ8=;
        b=pdBV/niOmmSRULSYUVlhWyXr02HPuwkALgG7/EgBz3cNV/crjRPDrFd8f0iK4lX5F7
         iMVpsRAwHQ4mF1CQqSfq6nzWvHbZryUK78a2mTxymQFblIZh5Br5h4YS5ptpa6+DBu6l
         198OPEtsxmxaYZdVIKZahJB/nENVyAqR86U2PxNqWejQ7JpdGeoCjtEiJxIiPYvl5/5q
         HBCh/hyGYCLSKaX+/277IFSCRkEW5T7GPrDuUTRaaG5BaPnDQhhgsof3Wh4ojBvZqTFJ
         DoIN0sxuEh0LR4P9FE4ETh4HsPGijYHFzFlvDEe3Wl0S5hHhZS19vPx3INq/JjbIiDXg
         PIyg==
X-Gm-Message-State: AOAM531GcsK+jFtDXlfaLKYjlzBUAE8hRfB8uuj1/rvaguUOTzA1KKuj
        krFske/W+Szj3KZd2WBW+ehajTWeQMxYYe6uSXN+qBeBW9Xvzpz36z74Y68VM9Ixplk9Z3oBBGn
        25clooc9o0LL6
X-Received: by 2002:a17:906:4408:b0:6da:bec1:2808 with SMTP id x8-20020a170906440800b006dabec12808mr278740ejo.543.1646840404469;
        Wed, 09 Mar 2022 07:40:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxx+gvGRmVfFoZip0H7v1AKRQ8cZ9dAFh83V03KTg4KylOolG2+P2B049hhG1L+4ZZBoqFKgw==
X-Received: by 2002:a17:906:4408:b0:6da:bec1:2808 with SMTP id x8-20020a170906440800b006dabec12808mr278714ejo.543.1646840404209;
        Wed, 09 Mar 2022 07:40:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n9-20020a05640205c900b00415fbbdabbbsm965130edx.9.2022.03.09.07.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 07:40:02 -0800 (PST)
Message-ID: <846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com>
Date:   Wed, 9 Mar 2022 16:39:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] KVM: x86/xen: PV oneshot timer fixes
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220309143835.253911-1-dwmw2@infradead.org>
 <20220309143835.253911-2-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309143835.253911-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 15:38, David Woodhouse wrote:
> +		if (hrtimer_active(&vcpu->arch.xen.timer))
> +			data->u.timer.expires_ns = vcpu->arch.xen.timer_expires;
> +		else
> +			data->u.timer.expires_ns = 0;
>   		r = 0;

This is still racy.  You should instead clear timer_expires in 
xen_timer_callback, and only do so after a *successful* write to the 
event channel (setting timer_pending is not enough).

Still, this only works if userspace reads the pending events *after* 
expires_ns.  It's the usual pattern:

	xen_timer_callback()		userspace
	------------------------	------------------------
	kvm_xen_set_evtchn_fast()	read timer_expires
	smp_wmb()			smp_rmb()
	expires_ns = 0;			read event channel

Now, if expires is read as 0, userspace surely will read the event properly.

Is this doable with the KVM ioctls that you have, considering that the 
pending events are in memory?  If not, you should add pause timer and 
resume timer ioctls.  These will change the hrtimer state without 
touching timer_expires and timer_pending.

But even better, and even simpler: just set timer_pending in 
xen_timer_callback, always go through the delayed injection path, and 
remove this "if" from KVM_XEN_VCPU_GET_ATTR.  Then there are no races, 
because KVM_RUN and KVM_XEN_VCPU_GET_ATTR are protected with vcpu->mutex:

	xen_timer_callback()		migration source
	------------------------	------------------------
					read event channel
	inc timer_pending
					ioctl(KVM_XEN_VCPU_GET_ATTR)
					  read timer_expires

timer_expires is *not* read as zero, because the clearing happens only 
in kvm_xen_inject_timer_irqs(), which cannot be concurrent with 
KVM_XEN_VCPU_GET_ATTR.  And the destination does:

	migration destination			xen_timer_callback()
	------------------------		------------------------
	ioctl(KVM_XEN_VCPU_SET_ATTR)
	  set timer_expires
	    hrtimer_start()
					        inc timer_pending
	ioctl(KVM_RUN)
	  kvm_xen_inject_timer_irqs()
	    kvm_xen_set_evtchn()
	      kvm_xen_set_evtchn_fast()
	    expires_ns = 0;

Paolo

