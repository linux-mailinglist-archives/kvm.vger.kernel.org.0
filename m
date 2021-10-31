Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F21440D79
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 08:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhJaHyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 03:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhJaHyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Oct 2021 03:54:22 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B11C061570
        for <kvm@vger.kernel.org>; Sun, 31 Oct 2021 00:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=rY9jtXknFzArop/HcmxsK8ra1hmgoCzXxz093GBO1Rk=; b=lwHHpSo++SidnmQd8jAUVANpIh
        6Yv/2Pg7HcBAqjUzAQoybu3NPsizroliVKk66qOJra0WD1rgtf+NRUGLVPvrQvt7IWDiaB/3t/qi+
        N3LUqHNQVybcOe8sAryzpCOeZdcjkIYrJd/rrIRj2fjZtYqNKg/P+Daymz1f95p8s98n/uPNcQU7K
        SPAs/7ay0aJqKnAP7l2M9a5FbDfPUNmwmLT1VKucJkl5Ga0DRwNBSuoWn6+h5O+9Y/+4hFpFrnIa8
        QKqsjuMLhwDRiFknlUDvQ3sFe+fJyCr0FPQFVFPzPO1pKNO4a6B7XVjxQNwGwegD0Tunge9vrUTUl
        BCh+OPBw==;
Received: from [2001:8b0:10b:1:401:b8e5:106a:b86] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mh5cs-00DMLu-Di; Sun, 31 Oct 2021 07:51:34 +0000
Date:   Sun, 31 Oct 2021 07:51:33 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: =?US-ASCII?Q?Re=3A_=5BEXTERNAL=5D_=5BPATCH=5D_KVM=3A_x86/xen=3A_Fix_runs?= =?US-ASCII?Q?tate_updates_to_be_atomic_when_preempting_vCPU?=
User-Agent: K-9 Mail for Android
In-Reply-To: <c0dd5fcd-343c-1186-0b1b-3a8ce8a797fe@redhat.com>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk> <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com> <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org> <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org> <95bee081-c744-1586-d4df-0d1e04a8490f@redhat.com> <8950681efdae90b089fcbe65fb0f39612b33cea5.camel@infradead.org> <c0dd5fcd-343c-1186-0b1b-3a8ce8a797fe@redhat.com>
Message-ID: <5CCCE89D-C00F-451A-B1E2-38D142ACD76B@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 31 October 2021 06:52:33 GMT, Paolo Bonzini <pbonzini@redhat=2Ecom> wro=
te:
>On 30/10/21 09:58, David Woodhouse wrote:
>>> Absolutely!  The fixed version of kvm_map_gfn should not do any
>>> map/unmap, it should do it eagerly on MMU notifier operations=2E
>> Staring at this some more=2E=2E=2E what*currently*  protects a
>> gfn_to_pfn_cache when the page tables change =E2=80=94 either because u=
serspace
>> either mmaps something else over the same HVA, or the underlying page
>> is just swapped out and restored?
>
>kvm_cache_gfn_to_pfn calls gfn_to_pfn_memslot, which pins the page=2E


It pins the underlying page but that doesn't guarantee that the page remai=
ns mapped at the HVA corresponding to that GFN, does it?

And I though the whole point of the repeated map/unmap was *not* to pin th=
e page, anyway?

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
