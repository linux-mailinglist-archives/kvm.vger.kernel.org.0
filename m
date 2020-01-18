Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94614195D
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 21:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgARUN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 15:13:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30628 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgARUN5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jan 2020 15:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579378436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAamMIuy9qZ1qnjqn1YuSKprV6Hn7tVGu8RDC7UeEBo=;
        b=DQVEQtm3OftQU6/vaWxBgQG+fpfhOMaJS2eej969NPY8279svzASg1t2mVqVZXqPU6jGN0
        1fzJNc6NB9P2CixtYf9SNXMmeuTw+4I46L9zciKpP1aBn7TkpVJGMWB/7sUesjP4w4Mq8I
        1jVWFx7rcBmyqtHUuJe+2WjnbqwN1VA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-oGnuodmjOneGcEFljCnWkw-1; Sat, 18 Jan 2020 15:13:55 -0500
X-MC-Unique: oGnuodmjOneGcEFljCnWkw-1
Received: by mail-wm1-f69.google.com with SMTP id 18so2966766wmp.0
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 12:13:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAamMIuy9qZ1qnjqn1YuSKprV6Hn7tVGu8RDC7UeEBo=;
        b=EqzoB5cwGFJjJWXAheG4sPQba6qOnr34OAp3ua6nLhiQVs5A/RmFKZnEVvwwM6nN8T
         gv5mJLrEjquf4iVah7fWGntb1+0wlSBgyrQqC5qPV79eFcvFfiu8H3UCcuHpmhhXYW+u
         RAzaGStq2dBm0KXz8AmFzt+lefFCGE8yEleoKnylbIPGVGzibRjNfL7vNUuOi/Jjq+v6
         qoQubLGjQIpcIZigUcs4um5HPRgNd5fl2oyuUsYoS2z+oo8r2wN49GQFdwZlXCEkykrC
         JP4Js6UJDy0D+1kxzKUer2tZg9+DwNjQP5iQvxNDwpeRA4iphuA83Vcr1ExlMr993ZEh
         b1fA==
X-Gm-Message-State: APjAAAWCC861piQuDH5Kt30qbQG/flIrCnRPjoL5h6vyQWhfteEBVawX
        Z/wn+b7t0+drZawwoKcait3cMYP5hQqI6yIXA7gOXQlo1ErIXyzrG8FcE5V99UmjHvOa7Q+1BYn
        ZU1RdiPbugu6y
X-Received: by 2002:a1c:62c1:: with SMTP id w184mr11141572wmb.150.1579378434179;
        Sat, 18 Jan 2020 12:13:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqy+zGJGN89q816CDTxTWRuSaIsyzxshooUEMHLhNjUkY0gfv8EIwHG7NcDm7EAJtTkTR+MjFQ==
X-Received: by 2002:a1c:62c1:: with SMTP id w184mr11141563wmb.150.1579378433963;
        Sat, 18 Jan 2020 12:13:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id m10sm40198204wrx.19.2020.01.18.12.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:13:53 -0800 (PST)
Subject: Re: [PATCH v2 10/13] KVM: x86: Protect memory accesses from
 Spectre-v1/L1TF attacks in x86.c
To:     Marios Pomonis <pomonis@google.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
References: <20191211204753.242298-1-pomonis@google.com>
 <20191211204753.242298-11-pomonis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8f47c12-3301-cb70-8d08-fe93450d19eb@redhat.com>
Date:   Sat, 18 Jan 2020 21:13:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211204753.242298-11-pomonis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/19 21:47, Marios Pomonis wrote:
> This fixes Spectre-v1/L1TF vulnerabilities in
> vmx_read_guest_seg_selector(), vmx_read_guest_seg_base(),
> vmx_read_guest_seg_limit() and vmx_read_guest_seg_ar().
> These functions contain index computations based on the
> (attacker-influenced) segment value.
> 
> Fixes: commit 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")

I think we could instead do

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2d4faefe8dd4..20c0cbdff1be 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5195,16 +5195,28 @@ int x86_decode_insn(struct x86_emulate_ctxt
*ctxt, void *insn, int insn_len)
 				ctxt->ad_bytes = def_ad_bytes ^ 6;
 			break;
 		case 0x26:	/* ES override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_ES;
+			break;
 		case 0x2e:	/* CS override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_CS;
+			break;
 		case 0x36:	/* SS override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_SS;
+			break;
 		case 0x3e:	/* DS override */
 			has_seg_override = true;
-			ctxt->seg_override = (ctxt->b >> 3) & 3;
+			ctxt->seg_override = VCPU_SREG_DS;
 			break;
 		case 0x64:	/* FS override */
+			has_seg_override = true;
+			ctxt->seg_override = VCPU_SREG_FS;
+			break;
 		case 0x65:	/* GS override */
 			has_seg_override = true;
-			ctxt->seg_override = ctxt->b & 7;
+			ctxt->seg_override = VCPU_SREG_GS;
 			break;
 		case 0x40 ... 0x4f: /* REX */
 			if (mode != X86EMUL_MODE_PROT64)

so that the segment is never calculated.

Paolo

