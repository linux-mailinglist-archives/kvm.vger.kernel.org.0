Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C39C35975E
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhDIIO2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:14:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232007AbhDIIO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 04:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617956054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M0WtewEB21VR9buYKo7EFc1sWeqSCtJz+J9VX2xS7d0=;
        b=cxlMHljZ5ACH7Jw9ioPrnNhRBaxOt45MLnAj5r5MIDUwpYS5rqyEYtZ3m8nGyTl27kjlg0
        mBOlBsI371D+NzBvd7AFFz/lEDqvtGGDLoADB3iDKWqNalU21r0eUeyX27QhbMVxNlu+11
        zA/048/mmVE8arTAWUPiC+y/P5hnp5U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-YvSxH5ReMuKJITkIC9HFiQ-1; Fri, 09 Apr 2021 04:14:12 -0400
X-MC-Unique: YvSxH5ReMuKJITkIC9HFiQ-1
Received: by mail-ej1-f72.google.com with SMTP id gn30so1889062ejc.3
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 01:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0WtewEB21VR9buYKo7EFc1sWeqSCtJz+J9VX2xS7d0=;
        b=W50t6XWX1mIHXUI1rG6IfLDIc/E9u5IncDJzZwoqDf1uFzTmKWpvW/9QCkuYLXxCuX
         YmxFcVuy5ryiJaLQqcPsoBV3+IjkedGTZuhKEuL1I8fdUs3BYnyU/7EgIMwAMcCyp2hc
         tSmtLOpEuCuOZpgQ2Sf263wAtD8+j2CkmPP15KpbLgqbQxfGWUmWIGqI69HOpMgEoH9O
         C5OVLZ40IkBlU8kd4wnPlNEGAEnUtpapn0CpAUsC5iEwMe1rI2+yrIMljb3I8XjcEgPx
         sgNVtKh2mBL37TsJ7JZyxasKRv37Q4uhMhWgbckQ1gxiZ634ytXjo9gjpIKwICzQXLBW
         QZnw==
X-Gm-Message-State: AOAM533gQ6cPCj12Ou/4w3Elx/tbtAq0n8jnqcuWy9O80dcs358Y48CX
        As8TU9gn+R8fhTdoD0hgjQO2DGzibIHwk/oIhb66m1G8gKADkaKM8NFNAHvn+3T3XaZ2fSalLoo
        6cj1+TcUiZE6X
X-Received: by 2002:a17:906:468b:: with SMTP id a11mr14853935ejr.190.1617956051452;
        Fri, 09 Apr 2021 01:14:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZDjr8pGY0n9Fs4qsXTDO5ldcdsheAJLSO7rFz9v3VPmkLdykCNxPW8r3nTwSE1zNy8TkPew==
X-Received: by 2002:a17:906:468b:: with SMTP id a11mr14853907ejr.190.1617956051215;
        Fri, 09 Apr 2021 01:14:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id rh6sm853598ejb.39.2021.04.09.01.14.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 01:14:10 -0700 (PDT)
To:     jejb@linux.ibm.com, Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, frankeh@us.ibm.com
References: <20210316014027.3116119-1-natet@google.com>
 <20210402115813.GB17630@ashkalra_ubuntu_server>
 <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com>
 <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
 <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com>
 <fc32a469ae219763f80ef1fc9f151a62cfe76ed6.camel@linux.ibm.com>
 <CABayD+c22hgPtjJBLkhyvyt+WAKXhoQOM6n0toVR1XrFY4WHAw@mail.gmail.com>
 <75863fa3f1c93ffda61f1cddfef0965a0391ef60.camel@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <ed7c38cd-4cfd-9f36-dd81-b8d699fd498d@redhat.com>
Date:   Fri, 9 Apr 2021 10:14:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <75863fa3f1c93ffda61f1cddfef0965a0391ef60.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/21 03:18, James Bottomley wrote:
> If you want to share ASIDs you have to share the firmware that the
> running VM has been attested to.  Once the VM moves from LAUNCH to
> RUNNING, the PSP won't allow the VMM to inject any more firmware or do
> any more attestations.

I think Steve is suggesting to just change the RIP of the mirror VM, 
which would work for SEV but not SEV-ES (the RAM migration helper won't 
*suffice* for SEV-ES, but perhaps you could use the PSP to migrate the 
VMSA and the migration helper for the rest?).

If you want to use a single firmware binary, SEC does almost no I/O 
accesses (the exception being the library constructor from 
SourceLevelDebugPkg's SecPeiDebugAgentLib), so you probably can:

- detect the migration helper hardware in PlatformPei, either from 
fw_cfg or based on the lack of it

- either divert execution to the migration helper through 
gEfiEndOfPeiSignalPpiGuid, or if it's too late add a new boot mode and 
PPI to DxeLoadCore.

Paolo

> What you mirror after this point can thus only
> contain what has already been measured or what the guest added.  This
> is why we think there has to be a new entry path into the VM for the
> mirror vCPU.

