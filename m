Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E6D669A07
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjAMOZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 09:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjAMOYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 09:24:20 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F710FDF;
        Fri, 13 Jan 2023 06:16:54 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5D5741EC04C1;
        Fri, 13 Jan 2023 15:16:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673619410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XYtqfhZKFK7PaSqp9fuWWHAp6AYDAbDdbgbeeBoQDPw=;
        b=nYmdzgEuSjI5cCOeBGcx/PixXKD2yIek0jfY+hJjIFI4n5nwUrIuJrZNqewFOMW0YJBonI
        cV9hqB9im51KA+msRMViQta8N3rmOPw5Gz0A4II5943TZ4R6nBUmwJZn3noP2dPeST1jHp
        Pa1jJq/Qg1X5pvW7g+YHyx0RaQ4O4Rk=
Date:   Fri, 13 Jan 2023 15:16:46 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>,
        chao.p.peng@linux.intel.com
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <Y8FnzpJyPMYDl0CA@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <Y6Xd0ruz3kMij/5F@zn.tnic>
 <20230105021419.rs23nfq44rv64tsd@amd.com>
 <Y7bnE5bTUb6fQiX/@zn.tnic>
 <20230105181741.q6mq37gvcjk5nbjg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230105181741.q6mq37gvcjk5nbjg@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 12:17:41PM -0600, Michael Roth wrote:
> In the case of SEV, it would still be up to userspace whether or not it
> actually wants to make use of UPM functionality like KVM_SET_MEMORY_ATTRIBUTES
> and private memslots. Otherwise, to maintain backward-compatibility, 
> userspace can do things as it has always done and continue running SEV without
> relying on private memslots/KVM_SET_MEMORY_ATTRIBUTES or any of the new ioctls.
> 
> For SNP however it is required that userspace uses/implements UPM
> functionality.

Makes sense to me.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
