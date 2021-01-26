Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A821305C5C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313039AbhAZWrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404129AbhAZUud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 15:50:33 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC72C061786
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 12:49:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s24so1397812pjp.5
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 12:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=JT5edQcn2lC/ohAJBe7VJY+gZeoJrzYd010rHqJGKDE=;
        b=Sl3WiOu4tIDOkkgv6i4aMIADj6Mw5A+pPOV31fbYQXGVQgOWouYMM9sniqU/pYH0k7
         2bREpiqbqKcRGqldVB4KKeo0Crk7SCoIXJWfguKvvlG8NCnvIuoyx5dlIZKLjioqq8dd
         UOkv/2z8yKxiOcEI6Qx+6Jjygo437bYF0l+IWzWFxzmvNrQi2oKLFiTj9uHv18Vo+8LS
         SXfRYG5Bu3tI76sinpnZrXtxRnYYxLP7ukt94RAtwQabXFW7v37K9A3D3MX8L4iu30Gc
         BV5CZUT7tAIm/dQbcvnszeOQCpOd+2emTElIqjZRG/A8fPqerkeY6wXr7UKHybt0vmC8
         +gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=JT5edQcn2lC/ohAJBe7VJY+gZeoJrzYd010rHqJGKDE=;
        b=dAjiHbEmXNCNEPR0bpTEtCv4PaPu6IItgaWMBmffwBkV9260GGjh4R1zxa1A9K5KQ4
         ky9oHX3/WJSy05VshUDcvvmpOnr2hnEe508zXYgD5PS64KIukoaNCRLBp/gfjLDYCmTb
         L9RWbpLwfmhI0wKGDUiO2mARLC270L3bOXfrpeqJG2rWbqIMMXR/q6Nam/uuaThR0o29
         hV8kIg2HZNkg42idKvPp8AB12B0htHbnnSuleVnwUeagJg7kQoucS5VyvHLZeshAXjLt
         BkHpIM3IG4yeX6kMFNH2BMxO9cdiygV3VSKQFHdFBc/URp8bzZfyNM4i+8mVLjHH5cz5
         6lAg==
X-Gm-Message-State: AOAM531v0jm+DSpOIcRJgzTYHW3IjdV7exf97upwPrOYGSVqhOy79nL7
        XEOciZz4RNzoZiIzCKfbxTFxTQ==
X-Google-Smtp-Source: ABdhPJwA1UPfoLVM0WjNCKLOq5x/h3QTY0cFUQ35qcbp6rEGWNEdcfmYEUqAIdnU/kAhNaggnal1yw==
X-Received: by 2002:a17:902:f683:b029:de:18c7:41fa with SMTP id l3-20020a170902f683b02900de18c741famr7595126plg.57.1611694157738;
        Tue, 26 Jan 2021 12:49:17 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id 67sm24396pfv.20.2021.01.26.12.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 12:49:15 -0800 (PST)
Date:   Tue, 26 Jan 2021 12:49:14 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Sean Christopherson <seanjc@google.com>
cc:     Tom Lendacky <thomas.lendacky@amd.com>, Tejun Heo <tj@kernel.org>,
        Vipin Sharma <vipinsh@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Grimm, Jon" <jon.grimm@amd.com>,
        "Van Tassell, Eric" <eric.vantassell@amd.com>, pbonzini@redhat.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
In-Reply-To: <YAopkDN85GtWAj3a@google.com>
Message-ID: <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
References: <YAICLR8PBXxAcOMz@mtj.duckdns.org> <YAIUwGUPDmYfUm/a@google.com> <YAJg5MB/Qn5dRqmu@mtj.duckdns.org> <YAJsUyH2zspZxF2S@google.com> <YAb//EYCkZ7wnl6D@mtj.duckdns.org> <YAfYL7V6E4/P83Mg@google.com> <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com> <YAmj4Q2J9htW2Fe8@mtj.duckdns.org> <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com> <YAopkDN85GtWAj3a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jan 2021, Sean Christopherson wrote:

> True, but the expected dual-usage is more about backwards compatibility than
> anything else.  Running an SEV-ES VM requires a heavily enlightened guest vBIOS
> and kernel, which means that a VM that was created as an SEV guest cannot easily
> be converted to an SEV-ES guest, and it would require cooperation from the guest
> (if it's even feasible?).
> 
> SEV-SNP, another incremental enhancement (on SEV-ES), further strengthens the
> argument for SEV and SEV-* coexistenence.  SEV-SNP and SEV-ES will share the
> same ASID range, so the question is really, "do we expect to run SEV guests and
> any flavor of SEV-* guests on the same platform".  And due to SEV-* not being
> directly backward compatible with SEV, the answer will eventually be "yes", as
> we'll want to keep running existing SEV guest while also spinning up new SEV-*
> guests.
> 

Agreed, cloud providers will most certainly want to run both SEV and SEV-* 
guests on the same platform.

> That being said, it's certainly possible to abstract the different key types
> between AMD and Intel (assuming s390 won't use the cgroup due to it's plethora
> of keys).  TDX private keys are equivalent to SEV-ES ASIDs, and MKTME keys (if
> the kernel ever gains a user) could be thrown into the same bucket as SEV IDs,
> albeit with some minor mental gymnastics.
> 
> E.g. this mapping isn't horrendous:
> 
>   encrpytion_ids.basic.*       == SEV   == MKTME
>   encrpytion_ids.enhanced.*    == SEV-* == TDX
> 
> The names will likely be a bit vague, but I don't think they'll be so far off
> that it'd be impossible for someone with SEV/TDX knowledge to glean their intent.
> And realistically, if anyone gets to the point where they care about controlling
> SEV or TDX IDs, they've already plowed through hundreds of pages of dense
> documentation; having to read a few lines of cgroup docs to understand basic vs.
> enhanced probably won't faze them at all.
> 

The abstraction makes sense for both AMD and Intel offerings today.  It 
makes me wonder if we want a read-only 
encryption_ids.{basic,enhanced}.type file to describe the underlying 
technology ("SEV-ES/SEV-SNP", "TDX", etc).  Since the technology is 
discoverable by other means and we are assuming one encryption type per 
pool of encryption ids, we likely don't need this.

I'm slightly concerned about extensibility if there is to be an 
incremental enhancement atop SEV-* or TDX with yet another pool of 
encryption ids.  (For example, when we only had hugepages, this name was 
perfect; then we got 1GB pages which became "gigantic pages", so are 512GB 
pages "enormous"? :)  I could argue (encryption_ids.basic.*,
encryption_ids.enhanced.*) should map to 
(encryption_ids.legacy.*, encryption_ids.*) but that's likely 
bikeshedding.

Thomas: does encryption_ids.{basic,enhanced}.* make sense for ASID 
partitioning?

Tejun: if this makes sense for legacy SEV and SEV-* per Thomas, and this 
is now abstracted to be technology (vendor) neutral, does this make sense 
to you?
