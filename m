Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AB34FDA5
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 12:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbhCaJ7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 05:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234629AbhCaJ7c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 05:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617184771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qsqxfwVHrmfsyTMmPvqiQy5Due+Xql9QpbIFHBdT44A=;
        b=cMFbnZuz/ESgPq/ovKxGqCyoH4WlD2AWyHz2BVoIWW1T4SQXEMp9Y0HXAklL/F+HqLrzUL
        W4NCDnrA/AwthUExMRg3WFs/gnROdidI5Yk4iqJcTWLxDDTNvvnyVfffamW3s9NJv+m3HG
        JvfDU5KvvQabISvY43HmcjMT/HXKarw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-pgsyjQ6-POiuqT_BYe2K_Q-1; Wed, 31 Mar 2021 05:59:29 -0400
X-MC-Unique: pgsyjQ6-POiuqT_BYe2K_Q-1
Received: by mail-ed1-f70.google.com with SMTP id t27so839994edi.2
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 02:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qsqxfwVHrmfsyTMmPvqiQy5Due+Xql9QpbIFHBdT44A=;
        b=OscDdTvMepX4UUuEbEEZJvIJi0xW13InTictmkmzdQr015znh3lqvYymQZw6nr3U1h
         pCK1EHOSEmJivSBfgMNjb6Eqhhi5NSZJaITbu65Z5bQlJFYBGjLhg+cVzSvNn2VLiaT0
         7/h+ffvCxuZUx7hPF54rMtAtWjgRvry0yRM68SGDXxdl4bqyMB/MNYA41dOKkD6lq7cH
         PhEuWo1XJifKpquXm1y6xGbw2VAa6GEZ0KaBbVM64EaTnyqBkzUsbpXxTqb9G+5B9GLM
         1ahq8AbbYPEMa1ok5gH18zjK3Af7O2v5oSbNrJNSoPOXUjprDtVZplAqdptDANeohFbC
         jANA==
X-Gm-Message-State: AOAM530Ks+e/8YwDNmMgODMTrQD3IiR1sNazX//FKAmoltjvVtkwSsoc
        xESzyWWaqok2UdFU/M2+em3FFT71f2zPldg1JsmlvdVZjnQLmqlygJX0Q+dzEOsQAOQO8gS6zQQ
        Xo+WuOaro2X0A
X-Received: by 2002:a17:906:9714:: with SMTP id k20mr2576837ejx.519.1617184768792;
        Wed, 31 Mar 2021 02:59:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzwl88y+LANJ8ILEZrk/v4Wj3wP1EQ+m2kd5oggG1DBZv1vJGMPUQhCP9KJR1ZEVYELwNj1w==
X-Received: by 2002:a17:906:9714:: with SMTP id k20mr2576831ejx.519.1617184768636;
        Wed, 31 Mar 2021 02:59:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cy5sm1173596edb.46.2021.03.31.02.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 02:59:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide
 maybe-negative 'hv_clock->system_time' in compute_tsc_page_parameters()
In-Reply-To: <7c6f61e9-f2a6-46dc-7ab6-dc6ae86c7b60@redhat.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <20210330131236.GA5932@fuller.cnet> <87ft0cu2eq.fsf@vitty.brq.redhat.com>
 <4d7f375c-c912-fbeb-edd1-03d742d49dcb@redhat.com>
 <87a6qju97s.fsf@vitty.brq.redhat.com>
 <7c6f61e9-f2a6-46dc-7ab6-dc6ae86c7b60@redhat.com>
Date:   Wed, 31 Mar 2021 11:59:27 +0200
Message-ID: <871rbvtzi8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 31/03/21 08:29, Vitaly Kuznetsov wrote:
>> I'm leaning towards making a v3 and depending on how complex it's going
>> to look like we can decide which way to go.
>
> As you prefer, but I would have no problem with committing v2 for now. 
>  From the point of view of system_time being a signed delta your v2 is 
> not a regression.

Ok, I convinced myself this is correct:

@@ -5744,8 +5745,22 @@ long kvm_arch_vm_ioctl(struct file *filp,
                 * pvclock_update_vm_gtod_copy().
                 */
                kvm_gen_update_masterclock(kvm);
-               now_ns = get_kvmclock_ns(kvm);
-               kvm->arch.kvmclock_offset += user_ns.clock - now_ns;
+
+               /*
+                * This pairs with kvm_guest_time_update(): when masterclock is
+                * in use, we use master_kernel_ns + kvmclock_offset to set
+                * unsigned 'system_time' so if we use get_kvmclock_ns() (which
+                * is slightly ahead) here we risk going negative on unsigned
+                * 'system_time' when 'user_ns.clock' is very small.
+                */
+               spin_lock(&ka->pvclock_gtod_sync_lock);
+               if (kvm->arch.use_master_clock)
+                       now_ns = ka->master_kernel_ns;
+               else
+                       now_ns = get_kvmclock_base_ns();
+               ka->kvmclock_offset = user_ns.clock - now_ns;
+               spin_unlock(&ka->pvclock_gtod_sync_lock);
+
                kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
                break;
        }

In !masterclock case kvm_guest_time_update() uses get_kvmclock_base_ns()
(and get_kvmclock_ns() is just get_kvmclock_base_ns() + ka->kvmclock_offset)
so we're good. Also, it looks like a good idea to put the whole
calculation under spinlock here.

Personally, I like this a little bit more than treating 'system_time' as
signed, what do you guys think?

-- 
Vitaly

