Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6636E23B
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 01:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhD1Xnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 19:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhD1Xnl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 19:43:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619653375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WCGTGrknZeE7eCqq8B0KPNhvevrJ02XQwZZ1Z+q/y2w=;
        b=csfzy3AWzuCILwDqim2Pe0dOMOv4643b9R9iI0gtqVAAE6W1hg0GvY6ZGwy+05780DJS3N
        NjmA8kKjDrakMGzzYRzuoUIbJejvrqihdShwL/nxm5BCdom0J5gwtogvzVFrE7Sq3mdKSH
        WCUYfPXOzdEZ6YISTzo95wTsdkEUkXo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-CAhPOob3MuKvGDEWv_L-qA-1; Wed, 28 Apr 2021 19:42:52 -0400
X-MC-Unique: CAhPOob3MuKvGDEWv_L-qA-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a50cb8a0000b0290387e0173bf7so3747995edi.8
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 16:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WCGTGrknZeE7eCqq8B0KPNhvevrJ02XQwZZ1Z+q/y2w=;
        b=lfVXVol3bgCXy4HfS8GV8OG9+DQywhPI8Xu7yppq8DxGqwRASDP6ZpqnqYctg8QstP
         D6lO6iKstW5N9uUwTIytjUIOgm3juqKT7ygLVjm+HikP1+1OvVv8xSyoSRnVNnOlyuV2
         1YV39rvwBSlgm1zT5NoAgMjH4nLn0H/b8NzwmfEEXzjAS/c4E03WQCwYZdTk40ZC5YT9
         MY6RjEnGFunYLNoW5k6Y1aaCj5X55gRzK4ftqhNX6YqdI+8ZcIaiEzfRjN7SiGtJgQP/
         ab7o5qSI+EywN3k3Skk+XjmH5tuMCOFNx7hJ+DFYcvEHdgQiwHe2SftVajzQJDt0Ctcy
         gbuA==
X-Gm-Message-State: AOAM532z05xivSs0l7dOa9MY8mnUFyxtfrz61A/5Deh9UU/YIK+k5U/J
        Hd3OJ4ypmpd85+34G849BPpXlRDXA1TuH30BwPHWXdLcvi6GShXfyl1CnNEkKRiv17ibo8Tzsvs
        e7spD9OlrNc8p
X-Received: by 2002:a17:906:2e17:: with SMTP id n23mr4703492eji.266.1619653370834;
        Wed, 28 Apr 2021 16:42:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvq4EViWh9nuBMUH/uXQuJHoWkOTGTEPkDOPHSwlXpSrpAi3mHmdhuz3EwJdYuJevA/tJwUA==
X-Received: by 2002:a17:906:2e17:: with SMTP id n23mr4703476eji.266.1619653370672;
        Wed, 28 Apr 2021 16:42:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id i19sm710063ejd.114.2021.04.28.16.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 16:42:50 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210427223635.2711774-1-bgardon@google.com>
 <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com>
 <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
 <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
 <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com>
 <CANgfPd_S=LjEs+s2UzcHZKfUHf+n498eSbfidpXNFXjJT8kxzw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
Message-ID: <16b2f0f3-c9a8-c455-fff0-231c2fe04a8e@redhat.com>
Date:   Thu, 29 Apr 2021 01:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_S=LjEs+s2UzcHZKfUHf+n498eSbfidpXNFXjJT8kxzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 23:46, Ben Gardon wrote:
> On Wed, Apr 28, 2021 at 2:41 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 28/04/21 22:40, Ben Gardon wrote:
>>> ... However with the locking you propose below, we might still run
>>> into issues on a move or delete, which would mean we'd still need the
>>> separate memory allocation for the rmaps array. Or we do some
>>> shenanigans where we try to copy the rmap pointers from the other set
>>> of memslots.
>>
>> If that's (almost) as easy as passing old to
>> kvm_arch_prepare_memory_region, that would be totally okay.
> 
> Unfortunately it's not quite that easy because it's all the slots
> _besides_ the one being modified where we'd need to copy the rmaps.

Ah, now I understand the whole race.  And it seems to me that if one
kvm_dup_memslots within the new lock fixed a bug, two kvm_dup_memslots
within the new lock are going to fix two bugs. :)

Seriously: unless I'm missing another case (it's late here...), it's
not ugly and it's still relatively easy to explain.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2799c6660cce..48929dd5fb29 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1270,7 +1270,7 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
  	return 0;
  }
  
-static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
+static void install_new_memslots(struct kvm *kvm,
  		int as_id, struct kvm_memslots *slots)
  {
  	struct kvm_memslots *old_memslots = __kvm_memslots(kvm, as_id);
@@ -1280,7 +1280,9 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
  
  	rcu_assign_pointer(kvm->memslots[as_id], slots);
+	mutex_unlock(&kvm->slots_arch_lock);
  	synchronize_srcu_expedited(&kvm->srcu);
+	kvfree(old_memslots);
  
  	/*
  	 * Increment the new memslot generation a second time, dropping the
@@ -1302,8 +1304,6 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
  	kvm_arch_memslots_updated(kvm, gen);
  
  	slots->generation = gen;
-
-	return old_memslots;
  }
  
  /*
@@ -1342,6 +1342,7 @@ static int kvm_set_memslot(struct kvm *kvm,
  	struct kvm_memslots *slots;
  	int r;
  
+	mutex_lock(&kvm->slots_arch_lock);
  	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
  	if (!slots)
  		return -ENOMEM;
@@ -1353,14 +1354,7 @@ static int kvm_set_memslot(struct kvm *kvm,
  		 */
  		slot = id_to_memslot(slots, old->id);
  		slot->flags |= KVM_MEMSLOT_INVALID;
-
-		/*
-		 * We can re-use the old memslots, the only difference from the
-		 * newly installed memslots is the invalid flag, which will get
-		 * dropped by update_memslots anyway.  We'll also revert to the
-		 * old memslots if preparing the new memory region fails.
-		 */
-		slots = install_new_memslots(kvm, as_id, slots);
+		install_new_memslots(kvm, as_id, slots);
  
  		/* From this point no new shadow pages pointing to a deleted,
  		 * or moved, memslot will be created.
@@ -1370,6 +1364,9 @@ static int kvm_set_memslot(struct kvm *kvm,
  		 *	- kvm_is_visible_gfn (mmu_check_root)
  		 */
  		kvm_arch_flush_shadow_memslot(kvm, slot);
+
+		mutex_lock(&kvm->slots_arch_lock);
+		slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
  	}
  
  	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
@@ -1377,16 +1374,17 @@ static int kvm_set_memslot(struct kvm *kvm,
  		goto out_slots;
  
  	update_memslots(slots, new, change);
-	slots = install_new_memslots(kvm, as_id, slots);
+	install_new_memslots(kvm, as_id, slots);
  
  	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
-
-	kvfree(slots);
  	return 0;
  
  out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		slot = id_to_memslot(slots, old->id);
+		slot->flags &= ~KVM_MEMSLOT_INVALID;
  		slots = install_new_memslots(kvm, as_id, slots);
+	}
  	kvfree(slots);
  	return r;
  }

One could optimize things a bit by reusing the allocation and only
doing a memcpy from the new memslots array to the old one under the
slots_arch_lock.  (Plus the above still lacks a mutex_init and
should be split in two patches, with the mutex going in the second;
but you get the idea and code sometimes is easier than words).

Paolo

