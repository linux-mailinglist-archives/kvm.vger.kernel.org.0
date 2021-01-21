Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD62FDE5D
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390906AbhAUBBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390591AbhAUATv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 19:19:51 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D40BC061757
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 16:19:09 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id c132so93757pga.3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 16:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YuYBfklFhpscFI2MvmVjz7cptai+tJdc1LXs5C+cN9I=;
        b=IafP9aBBZYJbp61JNTSQCxx/cZip//xHYSQl2qsU5Kynwx4DekHZ1koZaSGyCYQMFf
         b4TbzloZGl5fEfIN8OvBloos6j8vJ+obqFuZ7iUSCtTwDbmU1Q2534WkZckzk4Z/w5mh
         M+9vOBhDz4kYxAI/3IUM768SAFP0KsoojWg3ByF6KtTMvz5+EC92HIyNMXcRfdIAS9NL
         e16OUwbAR3gsN+uCNeErhHlxupo2uc55CC4dFXI+1HBw0O8JyuIUEhw94a7yYYDycNc+
         oARtcosxpAuTfoO//uVESSIEhWiy3M8uuAZCBEOsqvQgHiBGCgUxmpJy2xYj3JNrE6Ks
         M3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YuYBfklFhpscFI2MvmVjz7cptai+tJdc1LXs5C+cN9I=;
        b=fJqoGtojKo/IsYD1bZBtsyzPyHuSUUQtV3MNALQyeeMneCSXBnwhxSAH7Pb0PH3bEK
         jCUAvSnO36kvknppnyZpcYHurIl/rTB+SRyywi5xD6eaNRM0DhXSzPs08Egqus0pCAzL
         gI9Apuk0W7cyUS8yQtVhQGDewFQMzvAPEqORg0AkIxHDzhV0zbMTEeAn8XZMkgY6zW4A
         uRN3B6BmG0aJ2Xbt+9YOrioTg7MciSVQYYRL7i5pvugFXNnEeHg6E1xnBu/rImNWQn61
         3ZVGpAed10bN0FbmtbGIiUZIBgMnMDXlZPEYoPkbzIgR6ahSSGeHisUeX1cOPMvTfM30
         3FyA==
X-Gm-Message-State: AOAM532fBIZReRByZ9g//K87I3GksetUaiqrrslBZjYsVEKqW+n1FcdP
        5nbAfmynIWi4up4qv1M/8DRXgA==
X-Google-Smtp-Source: ABdhPJxqlMiZULHRMbpFS7PiM1m5iPT8o4qCzlkYIzGD9aSJxTbTdbjUZIY0Qx7CN/exN4CXMGBEpg==
X-Received: by 2002:aa7:80d5:0:b029:1a3:832a:1fd0 with SMTP id a21-20020aa780d50000b02901a3832a1fd0mr11627762pfn.6.1611188348723;
        Wed, 20 Jan 2021 16:19:08 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 73sm3541205pga.26.2021.01.20.16.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 16:19:07 -0800 (PST)
Date:   Wed, 20 Jan 2021 16:19:01 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
Message-ID: <YAjIddUuw/SZ+7ut@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-16-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-16-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Wrap the MMU lock cond_reseched and needbreak operations in a function.
> This will support a refactoring to move the lock into the struct
> kvm_arch(s) so that x86 can change the spinlock to a rwlock without
> affecting the performance of other archs.

IMO, moving the lock to arch-specific code is bad for KVM.  The architectures'
MMUs already diverge pretty horribly, and once things diverge it's really hard
to go the other direction.  And this change, along with all of the wrappers,
thrash a  lot of code and add a fair amount of indirection without any real
benefit to the other architectures.

What if we simply make the common mmu_lock a union?  The rwlock_t is probably a
bit bigger, but that's a few bytes for an entire VM.  And maybe this would
entice/inspire other architectures to move to a similar MMU model.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..bbc8efd4af62 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -451,7 +451,10 @@ struct kvm_memslots {
 };

 struct kvm {
-       spinlock_t mmu_lock;
+       union {
+               rwlock_t mmu_rwlock;
+               spinlock_t mmu_lock;
+       };
        struct mutex slots_lock;
        struct mm_struct *mm; /* userspace tied to this vm */
        struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
