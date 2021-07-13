Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE303C6C09
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 10:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhGMIei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 04:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234305AbhGMIeh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 04:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626165107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPw81F/HlP2Vls5vGEhwPX6XDpvIte64RBD+kcDomLE=;
        b=FnoAOCSa28YPoKKE0NYvysRmByxSxV4F88zDKANeWdLt4liSBcrOO150YPV3N1oaoIbRkD
        ySe/s/d4E+01idTwV4s8cIfZonYDH3odlHg3SyAep3vHr+iupIW9RBWAidXylzuDwZ28lF
        3VytF7R42Brv6vlvfQDG5Suhzq7pE7Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-d3WmFL09M_axWOrX_9lWgA-1; Tue, 13 Jul 2021 04:31:46 -0400
X-MC-Unique: d3WmFL09M_axWOrX_9lWgA-1
Received: by mail-wm1-f70.google.com with SMTP id m40-20020a05600c3b28b02901f42375a73fso1105092wms.5
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 01:31:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gPw81F/HlP2Vls5vGEhwPX6XDpvIte64RBD+kcDomLE=;
        b=GbKdwrRfCz8Zg8zEU35+34T2bQ3p37e8h0xHuyaOqpTxQsnmJqa1Funz2Wse189Urz
         A7bJHVYsISeLNFHow8j8wd1HHV+QmM85lgzm7mCHvT4grXABcWN76AYJ7LVoEdEo1T03
         soBvvO2wXC2HhNo6Gl5dgbpy+VB4QaI6/tOySbQNTVQuWHbeNaidsfu/JtxvgTB4CmZF
         cEUVEdVjMCFF7V5eYrroj43Kbx4twva7/s18I3psc+sBriLpg8cHHmrfBWCPGROz1UMc
         sRquLG0WPYzsUUk9MkdaTmxLtXoNwTVjjCx+/C2mvhsEbbpZyudSsRlkw5AhIlykM66r
         bukw==
X-Gm-Message-State: AOAM5329pCPL51wCdcGMfxB3anyoDBn6cle3KgNmeRPy8674l7fd5q/+
        WVR3rFzHJWwPsxIyPEz58WyhTSloX2MQIqMIaqTDXYlqvUjN8xt997NfHKAhhC5dFOfOY4Mz547
        sHoitZGw/wWgB
X-Received: by 2002:a05:600c:2197:: with SMTP id e23mr3696666wme.101.1626165103725;
        Tue, 13 Jul 2021 01:31:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQgCJ+SPE6CleUWDxOeRUR4Zhk9tJ1RbkIN8Xf8LcJ/bbzquqsZufKX/Ba6LJpf/PuQcbQkA==
X-Received: by 2002:a05:600c:2197:: with SMTP id e23mr3696646wme.101.1626165103564;
        Tue, 13 Jul 2021 01:31:43 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id j6sm9010213wrm.97.2021.07.13.01.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:31:42 -0700 (PDT)
Date:   Tue, 13 Jul 2021 09:31:40 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Dov Murik <dovmurik@linux.ibm.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 0/6] Add AMD Secure Nested Paging (SEV-SNP) support
Message-ID: <YO1PbIPXem0E0Bgd@work-vm>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Dov Murik (dovmurik@linux.ibm.com) wrote:
> Brijesh,
> 
> On 10/07/2021 0:55, Brijesh Singh wrote:
> > SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
> > new hardware-based memory protections. SEV-SNP adds strong memory integrity
> > protection to help prevent malicious hypervisor-based attacks like data
> > replay, memory re-mapping and more in order to create an isolated memory
> > encryption environment.
> > 
> > The patches to support the SEV-SNP in Linux kernel and OVMF are available:
> > https://lore.kernel.org/kvm/20210707181506.30489-1-brijesh.singh@amd.com/
> > https://lore.kernel.org/kvm/20210707183616.5620-1-brijesh.singh@amd.com/
> > https://edk2.groups.io/g/devel/message/77335?p=,,,20,0,0,0::Created,,posterid%3A5969970,20,2,20,83891508
> > 
> > The Qemu patches uses the command id added by the SEV-SNP hypervisor
> > patches to bootstrap the SEV-SNP VMs.
> > 
> > TODO:
> >  * Add support to filter CPUID values through the PSP.
> > 
> > Additional resources
> > ---------------------
> > SEV-SNP whitepaper
> > https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf
> > 
> > APM 2: https://www.amd.com/system/files/TechDocs/24593.pdf (section 15.36)
> > 
> > GHCB spec:
> > https://developer.amd.com/wp-content/resources/56421.pdf
> > 
> > SEV-SNP firmware specification:
> > https://www.amd.com/system/files/TechDocs/56860.pdf
> > 
> > Brijesh Singh (6):
> >   linux-header: add the SNP specific command
> >   i386/sev: extend sev-guest property to include SEV-SNP
> >   i386/sev: initialize SNP context
> >   i386/sev: add the SNP launch start context
> >   i386/sev: add support to encrypt BIOS when SEV-SNP is enabled
> >   i386/sev: populate secrets and cpuid page and finalize the SNP launch
> > 
> >  docs/amd-memory-encryption.txt |  81 +++++-
> >  linux-headers/linux/kvm.h      |  47 ++++
> >  qapi/qom.json                  |   6 +
> >  target/i386/sev.c              | 498 ++++++++++++++++++++++++++++++++-
> >  target/i386/sev_i386.h         |   1 +
> >  target/i386/trace-events       |   4 +
> >  6 files changed, 628 insertions(+), 9 deletions(-)
> > 
> 
> It might be useful to allow the user to view SNP-related status/settings
> in HMP's `info sev` and QMP's qom-list/qom-get under
> /machine/confidential-guest-support .
> 
> (Not sure whether HMP is deprecated and new stuff should not be added
> there.)

It's still fine to add stuff to HMP, although generally you should be
adding it to QMP as well (unles sit's purely for debug and may change).

Dave

> Particularly confusing is the `policy` attribute which is only relevant
> for SEV / SEV-ES, while there's a new `snp.policy` attribute for SNP...
> Maybe the irrelevant attributes should not be added to the tree when not
> in SNP.
> 
> -Dov
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

