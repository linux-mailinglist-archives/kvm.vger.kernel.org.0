Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD28274352
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 15:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgIVNiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 09:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbgIVNia (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 09:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKA+W9RGb28j92jAhf1JQdc576NbRme2KTggAyn0cGE=;
        b=f3dG14wEUqDn2aB1m7zPz4zuaqlIv+he18EO60OSdWqgle6n1ppg9aCoI0qKPooWDMn81q
        AHGfvo5BSDmuQEGMQcq48cfv5xT+Jc7upd39FNon310qhsaXMO/2ChqVg1TlAZTt2fPcxq
        wj+vg2igqsIUgCj56Z5MwrCpWN1Tytc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-wKCr_gfwNE2CtVbkxHwRIQ-1; Tue, 22 Sep 2020 09:38:27 -0400
X-MC-Unique: wKCr_gfwNE2CtVbkxHwRIQ-1
Received: by mail-wr1-f72.google.com with SMTP id b7so7433242wrn.6
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 06:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WKA+W9RGb28j92jAhf1JQdc576NbRme2KTggAyn0cGE=;
        b=Y2tCMAKrsMiROH+1RDIDzTS9O5y+PlCSaIobtasjaqTN35MnsKQ8xq2WT7YME+SAZI
         d5lTg3b3XzyjdtH1v/Y4PcGayt7FTX2tA5fi55ICewb2GrSb7UkBVUQUQLx2nWuEJGaI
         ueBQCPJlnEM53k3SkDYIVrDKpmYO4uBoGELznoFPdYro1s8/D9S7oDay8yJI7Wfya2Pf
         fht+v4UoTQeITDGazvWE+tHwMOiGtfmPtnzL2SPPv2fBNUMU1hB/NyMJrY2Pqy8nWoSi
         gbdZi7RhMK92XuceZD81YForkbVO2RAzsOI784daNI6PgWmJbl6JJsd0lH7lOGgZ5iEd
         UJLg==
X-Gm-Message-State: AOAM532NoXH2V2JUTjgPviwZXfeU7M/0w7sTJmH43otGosVjmJmXmNBl
        F+4+jwd1tkJK4nLTX3QNdFKX74WL3WJuRkBUNqmCQgxn1fgvvcjgl2+KTQMgAe03G7pVck2/gTx
        M+kEL2F0s197m
X-Received: by 2002:adf:f88b:: with SMTP id u11mr5298170wrp.376.1600781905829;
        Tue, 22 Sep 2020 06:38:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ94kRCHGua3D6X0Y+ygEUAilwPvcCy+6DPODmbUzKE+wR5gnO6hv3RQDDn54DlvnBP+9nBA==
X-Received: by 2002:adf:f88b:: with SMTP id u11mr5298147wrp.376.1600781905609;
        Tue, 22 Sep 2020 06:38:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id c14sm27546575wrm.64.2020.09.22.06.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 06:38:25 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] KVM: VMX: Clean up IRQ/NMI handling
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a6aaa8a-c62c-5f7c-da3e-14a68a835487@redhat.com>
Date:   Tue, 22 Sep 2020 15:38:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915191505.10355-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/20 21:15, Sean Christopherson wrote:
> Clean up KVM's handling of IRQ and NMI exits to move the invocation of the
> IRQ handler to a standalone assembly routine, and to then consolidate the
> NMI handling to use the same indirect call approach instead of using INTn.
> 
> The IRQ cleanup was suggested by Josh Poimboeuf in the context of a false
> postive objtool warning[*].  I believe Josh intended to use UNWIND hints
> instead of trickery to avoid objtool complaints.  I opted for trickery in
> the form of a redundant, but explicit, restoration of RSP after the hidden
> IRET.  AFAICT, there are no existing UNWIND hints that would let objtool
> know that the stack is magically being restored, and adding a new hint to
> save a single MOV <reg>, <reg> instruction seemed like overkill.
> 
> The NMI consolidation was loosely suggested by Andi Kleen.  Andi's actual
> suggestion was to export and directly call the NMI handler, but that's a
> more involved change (unless I'm misunderstanding the wants of the NMI
> handler), whereas piggybacking the IRQ code is simple and seems like a
> worthwhile intermediate step.
> 
> Sean Christopherson (2):
>   KVM: VMX: Move IRQ invocation to assembly subroutine
>   KVM: VMX: Invoke NMI handler via indirect call instead of INTn
> 
>  arch/x86/kvm/vmx/vmenter.S | 34 +++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     | 61 +++++++++++---------------------------
>  2 files changed, 51 insertions(+), 44 deletions(-)
> 

Queued, thanks.

Paolo

