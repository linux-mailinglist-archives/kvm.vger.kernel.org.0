Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4746DFCB97
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 18:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKNRPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 12:15:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34991 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbfKNRPm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 12:15:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573751741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=gbTdjtPW0MKQv7Yl30zpGVmoWK5fxqvC+dh3W0bxxkg=;
        b=dZpObk7slTJptKcEM6/twMH0MUVKRww9vvglVA8lf5vVoEZpBgNGmCRz/qMG+FhVpLn1bD
        XCbRUUsptZpIhxP2shoysPLv/605z1OsBdb/eX47YjKbpaslrq1F6hjl9Vv1mjO5Bpe9Xa
        Qp/7lTsnSYs7k56BP6uh2f10hnVSdgk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-mV7QeVegPECUoEqlBYNUBQ-1; Thu, 14 Nov 2019 12:15:39 -0500
Received: by mail-wr1-f70.google.com with SMTP id 4so4792180wrf.19
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 09:15:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jpEt4kcWqvPkXm7gNvgLa7mz6uUYuQ+o9Pau2fsorwc=;
        b=W/8QqDEFMzmGHT53t+iLk8aoUyrv3fpW4nVrUJjoBKEd/HHuK33C2NtF0RNXHHTS+/
         rXFhR0zhYNWluD9cozOmLYTA5efsEbl44lKFFl6W/GteSeYsiMQx/NP64M3JBG59G7AF
         O67afFQU8wB69/g7XpPvp93sijGftP/zOBd9mZFiqiUV1SxqPRm/mrFBoxHwtuXal34R
         y99ulbF8Un1Wtb9XfLNLmpKyP3dR3dzahYcj4OQD0g2o9c++AYqKKogULGbWuhKmHTi6
         llv085BtoV1W6v3+rG1Cl1Hnnmm1P+wIZkGc+O3aUfsxEH1ftm7TRF7IgoQqcPHJ8lPx
         GwrQ==
X-Gm-Message-State: APjAAAWI+tn4kVQJpq3S//6MtsCpCfSvmZIZn8uuAr4nXankF2aKiKNC
        U7FL/QjRMPuasGRYxZGR3OIRiStI+xA7+kSGwYD6GapXJib0gB9VgFfZHW+w3wVHgVmQ7jqcWSr
        A9G+7Sre3RMU6
X-Received: by 2002:a1c:98c5:: with SMTP id a188mr8945113wme.133.1573751738553;
        Thu, 14 Nov 2019 09:15:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHamP9QriNwl6Ugw+S5huM16LiGTkmJeWuW/47AoXKLopL+QzkB/RXwKrqbj48LRbRjH6EPA==
X-Received: by 2002:a1c:98c5:: with SMTP id a188mr8945087wme.133.1573751738265;
        Thu, 14 Nov 2019 09:15:38 -0800 (PST)
Received: from [192.168.43.81] (mob-109-112-119-76.net.vodafone.it. [109.112.119.76])
        by smtp.gmail.com with ESMTPSA id w18sm7973435wrp.31.2019.11.14.09.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 09:15:37 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Take slots_lock when using
 kvm_mmu_zap_all_fast()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191113193032.12912-1-sean.j.christopherson@intel.com>
 <1b46d531-6423-3ccc-fc5f-df6fbaa02557@redhat.com>
 <20191114151051.GB24045@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7f710a08-b207-e9a8-bc42-cb67113a7c8a@redhat.com>
Date:   Thu, 14 Nov 2019 18:15:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114151051.GB24045@linux.intel.com>
Content-Language: en-US
X-MC-Unique: mV7QeVegPECUoEqlBYNUBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 16:10, Sean Christopherson wrote:
> On Thu, Nov 14, 2019 at 01:16:21PM +0100, Paolo Bonzini wrote:
>> On 13/11/19 20:30, Sean Christopherson wrote:
>>> Failing to take slots_lock when toggling nx_huge_pages allows multiple
>>> instances of kvm_mmu_zap_all_fast() to run concurrently, as the other
>>> user, KVM_SET_USER_MEMORY_REGION, does not take the global kvm_lock.
>>> Concurrent fast zap instances causes obsolete shadow pages to be
>>> incorrectly identified as valid due to the single bit generation number
>>> wrapping, which results in stale shadow pages being left in KVM's MMU
>>> and leads to all sorts of undesirable behavior.
>>
>> Indeed the current code fails lockdep miserably, but isn't the whole
>> body of kvm_mmu_zap_all_fast() covered by kvm->mmu_lock?  What kind of
>> badness can happen if kvm->slots_lock isn't taken?
>=20
> kvm_zap_obsolete_pages() temporarily drops mmu_lock and reschedules so
> that it doesn't block other vCPUS from inserting shadow pages into the ne=
w
> generation of the mmu.

Oh, of course.  I've worked on all this on the pre-5.4 MMU and that does
not have commit ca333add693 ("KVM: x86/mmu: Explicitly track only a
single invalid mmu generation").

I queued this patch with a small tweak to the commit message, to explain
why it doesn't need a stable backport.

Paolo

