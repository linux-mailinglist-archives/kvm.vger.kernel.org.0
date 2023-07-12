Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62441750D47
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbjGLP6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjGLP6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:58:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59207A2
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:58:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c04f5827eso6372333a12.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689177500; x=1691769500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JSfe+iQhaOkty+h2TVJBQr/8bx8KuzjcDDQ8OVQERKU=;
        b=vRBrZT2z3ZD2dgmquxtGdlOl50FV7kVqDS+Azde/DzjZhiZuwdv2z+9N5FH+ayaA8/
         CmlWKo7AfJ5aM2hPS6bbWKE7zVFDIAI8I0lwz9VdkrLf8gOaikkGqE+OdwZP6Wf+n+30
         ZXXLy44528gxLAWnWqzAOGszLF0akTdHqjFufYeAuhWmqOBHzq7vD3m0bwE/s3KOUxJe
         Mon0wSboS5XgFdZy4J8uI7jhvYuRMOh3r6K/gZbk1NOG5LvHDWNbg6Xd9wBRuXpay18+
         Wkqk0QYT3786zmXi9O3uhzoE74V/4gw1I2cMrJqKANPHIkd+cT9QdPtkAmtOsRL/P4nL
         NzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689177500; x=1691769500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JSfe+iQhaOkty+h2TVJBQr/8bx8KuzjcDDQ8OVQERKU=;
        b=FnvuuFzw7Qw/BgokfrAeh2euYLjb8XYT9+LUz/V1zjObYVfPKaDUFoABw87bGn/p6E
         jQi1SoFPau/GV8DRHviJGdvOGa/KiF6bKImc810FSvQZiH5qkwPXo+wmRgdl6UVrezUA
         TPQDmShuZHRxhceaszoO3PaiTa5geTVBukK6cnnBS91T/JeOmC1opgky1CI1JAzI7UQL
         aLTx0/aTtj57Y1VyyAqxLlhpGuAync6kb0IlPAYOoqJT9mfbpQR4Jq2xYLTP4GPpeA8B
         RrLcaMw9oqIvS5dGOGgiCiZumuHVhq8J1+qT3vlE7CkBFsXK6/ePC8zuvu56BcToNRTE
         q7zQ==
X-Gm-Message-State: ABy/qLYGFiEoJSOvEoJRDEl8bbzAteTcMqACD96wV/RNtfOC68K+wN+b
        A0nT0eN0t3w0B/E5B4/5S+cm2IPeFhM=
X-Google-Smtp-Source: APBJJlECNnNJUgQwvMg5NrFrIXDTEKM05BVCgydQ4nYR2joo5cvXqtlOpzf/MrJOQPNXY1eediHmPhMmoPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d48:0:b0:54f:d3ef:539b with SMTP id
 k69-20020a633d48000000b0054fd3ef539bmr10145825pga.12.1689177499683; Wed, 12
 Jul 2023 08:58:19 -0700 (PDT)
Date:   Wed, 12 Jul 2023 08:58:17 -0700
In-Reply-To: <20230707114107.73019-1-itazur@amazon.com>
Mime-Version: 1.0
References: <20200415023726.GD12547@linux.intel.com> <20230707114107.73019-1-itazur@amazon.com>
Message-ID: <ZK7NmfKI9xur/Mop@google.com>
Subject: Re: [PATCH 1/1] KVM: pass through CPUID(0x80000006)
From:   Sean Christopherson <seanjc@google.com>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Takahiro Itazuri <zulinx86@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trimmed the Cc to remove folks that no longer directly work on any of this stuff.

On Fri, Jul 07, 2023, Takahiro Itazuri wrote:
> Please forgive me if this is an absurd question.
> 
> Date:   Tue, 14 Apr 2020 19:37:26 -0700
> From:   Sean Christopherson <sean.j.christopherson@intel.com>
> >   Return the host's L2 cache and TLB information for CPUID.0x80000006
> >   instead of zeroing out the entry as part of KVM_GET_SUPPORTED_CPUID.
> >   This allows a userspace VMM to feed KVM_GET_SUPPORTED_CPUID's output
> >   directly into KVM_SET_CPUID2 (without breaking the guest).

Ha, this confused me for a bit.  While past me did technically write this changelog,
I was just massaging someone else's words.

I'm honestly a bit dubious of the claim that providing a zeroed out 0x80000006
would break the guest.  I'm pretty sure I chose that phrase based Eric's original
wording that KVM's "defaults" would be "necessary".

  Return L2 cache and TLB information to guests.
  They could have been set before, but the defaults that KVM returns will be
  necessary for usermode that doesn't supply their own CPUID tables.

I don't think it actually matters (see below), it's just a rather odd justification.

> I noticed that CPUID 0x80000005 also returns cache information (L1 Cache
> and TLB Information) when looking at AMD APM, while it is marked
> reserved on Intel SDM. What do you think about passing through CPUID
> 0x80000005 to guests?
> 
> To be honest, I'm not sure if it is harmless from security and
> performance perspectives in the first place.
>
> Regard security aspect, I'm a bit concerned that it could help malicious
> guests to know something to allow cache side channel attacks. However,
> CPUID 0x80000006 has already passed through L2 Cache and TLB and L3
> Cache Information. If passing through CPUID 0x80000006 is really fine,
> I'm guessing it is the case with CPUID 0x80000005 as well.

It's definitely harmless from a security perspective.  Userspace already has
access to this information as CPUID is NOT a priveleged instructions.  And the
kernel also publishes this information in sysfs, e.g. /sys/devices/system/cpu/cpuN/cache,
and AFAIK that's not typically restricted.

KVM must assume that any and all information visible to userspace is also visible
to the guest, e.g. even if KVM wanted to police CPUID, nothing would prevent
userspace from providing a paravirtual interface to the guest to enumerate
cache and TLB topology.

> In terms of performance, as far as I know, some softwares utilizes cache
> information to achieve better performance. To simply put, by letting
> guests know cache information, they may gain some benefits. Having said
> that, if I understand correctly, guests can be scheduled on CPUs that do
> not belong to the same group of CPUs that they run last time, unless
> guests are pinned to a specific set of host physical CPUs. In such
> cases, guests may not benefit from using cache information.

I would be quite surprised if homogeneous, a.k.a. non-hybrid, CPUs ever have
variable cache/TLB properties across cores.  Hybrid CPUs might be a different
story, but even then I gotta imagine that userspace software already has problems,
e.g. userspace processes will encounter variable cache/TLB behavior unless
userspace is affining all tasks.

Regardless, the decision on whether or not to report cache information via
KVM_GET_SUPPORTED_CPUID was made long, long ago, as KVM has enumerated CPUID.0x4
since basically forever.  So really this only affects TLB info, and since KVM
already spits out 0x80000006, it's just L1 TLB info.

I'm mildly tempted to remove 0x80000006, for similar reasons as commit 45e966fcca03
("KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID"),
but I suspect that would do more harm than good, e.g. Linux falls back to
0x80000005 and 0x80000006 when running on AMD without extended topology info.

> If I'm missing something or say something wrong, I'd appreciate it if
> you could correct me. If it sounds no problem, I'd like to send a patch
> for it.

I think it makes sense to enumerate 0x80000005.  Reporting 0x80000006 but not
0x80000005 seems to be the *worst* behavior, so as I see it, the decision is
really between adding 0x80000005 and removing 0x80000006.  Adding 0x80000005
appears to be the least risky choice given that KVM has reported 0x80000006 for
over three years.
