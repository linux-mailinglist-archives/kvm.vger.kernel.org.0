Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3848A0EF8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 03:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfH2Bll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 21:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfH2Bll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 21:41:41 -0400
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20AF385536
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 01:41:41 +0000 (UTC)
Received: by mail-pl1-f199.google.com with SMTP id g9so1052635plo.21
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 18:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8DWNu1dK4HKJfDzkOqyZXX+I5s8gHPW0nTQ4GZnnxHE=;
        b=qlSuwvSaUkC7NectFbRbI0Vip0kalJU1AeiWdE316tOREZbhh3sca7ZXrcHJtcwewq
         UDiy8mv4ip3R0bzb8PDDojox7HPX/ns7cNIGsPleIyhsntA4IMBcpIxAc0/mWH96uahD
         j7d0/UKuGx8Sr4pH8xUa7O0q5vJDot92QgrtjjaACLwA3NykvPyhD6c5qB0QNOJknEM7
         BQaMDabaircDlTzvyaS1h78miNL3japJHh3usYpXWNz8Zdtk98rymmuZUVhzD90UClrL
         yzGyBB1RSKYl8Rqb6typKCVSymaC09hT2n61uDmMqMPUc7+U+X3PlTbhSrbtHOnmnJvf
         0l/g==
X-Gm-Message-State: APjAAAVHPM7XKg7LgQxbcoIIpe/FW2niw9R/0QmGddASqwHCr/Ma1MuV
        eQu2uS1CN+x2LeL7a/2e7xxiUTXObJ578dKeNI6b+5Y6Pct7rLWEUAjS3ZrSz2d6m/JfnkLDiPb
        WqvFcAAGxKnC8
X-Received: by 2002:a17:90b:8e:: with SMTP id bb14mr7047943pjb.35.1567042900673;
        Wed, 28 Aug 2019 18:41:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwY+F2/S/0LgTY32xYN6uNnbYmaTrNV4G2U/b+SM1xbAWugSw5NKCTUFcLK4AWzt5fwKp5HPQ==
X-Received: by 2002:a17:90b:8e:: with SMTP id bb14mr7047931pjb.35.1567042900489;
        Wed, 28 Aug 2019 18:41:40 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s7sm728550pfb.138.2019.08.28.18.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 18:41:39 -0700 (PDT)
Date:   Thu, 29 Aug 2019 09:41:29 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/4] KVM: selftests: Move vm type into _vm_create()
 internally
Message-ID: <20190829014129.GE8729@xz-x1>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-2-peterx@redhat.com>
 <20190828112357.auyhr3de5reie6hs@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190828112357.auyhr3de5reie6hs@kamzik.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 01:23:57PM +0200, Andrew Jones wrote:

[...]

> 
> >  {
> >  	struct kvm_vm *vm;
> >  
> > @@ -139,8 +139,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> >  	TEST_ASSERT(vm != NULL, "Insufficient Memory");
> >  
> >  	vm->mode = mode;
> > -	vm->type = type;
> > -	vm_open(vm, perm, type);
> > +	vm->type = 0;
> >  
> >  	/* Setup mode specific traits. */
> >  	switch (vm->mode) {
> > @@ -190,6 +189,13 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> >  		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
> >  	}
> >  
> > +#ifdef __aarch64__
> > +	if (vm->pa_bits != 40)
> > +		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
>                                                     ^^
>                                                     should be vm->pa_bits

Thanks for spotting it!  Fixed this and also the rest of indent
issues.

Regards,

-- 
Peter Xu
