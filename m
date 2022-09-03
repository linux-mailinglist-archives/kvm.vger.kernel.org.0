Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1DB5ABDD8
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 10:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiICIbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 04:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICIbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 04:31:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BBE101DD;
        Sat,  3 Sep 2022 01:31:19 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-002-247-242-004.2.247.pool.telefonica.de [2.247.242.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 09E311EC06EE;
        Sat,  3 Sep 2022 10:31:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1662193874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dHXOkzxgjsBtZM539cRCQ2oOl4G/USWxuxSAXY3DyOs=;
        b=Gs6Qlvxs8gNpEUHeMBASMK9yQo6Y7FspgcI4jU/TDL4PyDkxNsQfAH1Paj6VGlvA4fTxXc
        rP1bxXy5M8rQhgmB6LUcaejLkEo6203LQUbYX892e1hz0XVqmaDIgGDePeuwjxC+1N/d/j
        TivrvEgG+eKbx+fbHeDorEmyY6hdGcU=
Date:   Sat, 03 Sep 2022 08:31:09 +0000
From:   Boris Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_Part2_v6_09/49=5D_x86/fault=3A_Add_sup?= =?US-ASCII?Q?port_to_handle_the_RMP_fault_for_user_address?=
In-Reply-To: <SN6PR12MB2767074DEB38477356A3C0F98E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com> <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com> <YvKRjxgipxLSNCLe@zn.tnic> <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com> <YvN9bKQ0XtUVJE7z@zn.tnic> <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com> <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com> <YxGoBzOFT+sfwr4w@nazgul.tnic> <SN6PR12MB2767E95BA3A99A6263F1F9AE8E7A9@SN6PR12MB2767.namprd12.prod.outlook.com> <YxLXJk36EKxldC1S@nazgul.tnic> <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com> <SN6PR12MB2767074DEB38477356A3C0F98E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
Message-ID: <BC747219-7808-4C39-A17C-A76B35DD6CB3@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On September 3, 2022 6:57:51 AM UTC, "Kalra, Ashish" <Ashish=2EKalra@amd=2E=
com> wrote:
>[AMD Official Use Only - General]
>
>So essentially we want to map the faulting address to a RMP entry, consid=
ering the fact that a 2M host hugepage can be mapped as=20
>4K RMP table entries and 1G host hugepage can be mapped as 2M RMP table e=
ntries=2E

So something's seriously confusing or missing here because if you fault on=
 a 2M host page and the underlying RMP entries are 4K then you can use pte_=
index()=2E

If the host page is 1G and the underlying RMP entries are 2M, pmd_index() =
should work here too=2E

But this piecemeal back'n'forth doesn't seem to resolve this so I'd like t=
o ask you pls to sit down, take your time and give a detailed example of th=
e two possible cases and what the difference is between pte_/pmd_index and =
your way=2E Feel free to add actual debug output and paste it here=2E

Thanks=2E

--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
