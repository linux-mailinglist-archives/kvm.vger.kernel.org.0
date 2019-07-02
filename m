Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F785D3BA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGBP7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:59:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41922 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfGBP7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:59:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so18460935wrm.8
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 08:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jotH9caGMGC489ehfl8p7vShSFt/Q8geYThDYUUhENg=;
        b=CfRwtrtMFY5tDjJ+Iwvx+5MD+IMN+RlGUGvjYPln4/c2E6fncW/CGgPVvZGDYvV87j
         i0TlzgPJRVBVsRthu5lT1fKwSahlVxKw+Wnu+H0ORj8VlRqWT+4Yuvs/t2t7dNEE7yWO
         ESg1jvnCJwkA2rGDGm70zbUZdyCuuxcxtXyR8ly1s+OqBNE6djvbkmTOAmFiyafDVh/X
         aq/cF9JFFAtmHSeguUxYmri21E8rNER9J5wbHq5GqubLx48rw1Mo9xDL8pwLhsHCbVBm
         edb3rpR/6/yMxjKq84i8D4o76iY5o36l9etnqUe0xKX1naArA+et9HSuaamgjlh820bp
         DacQ==
X-Gm-Message-State: APjAAAU0XoFkRdF+BcG4qNGrG3rqLBGvZErrJjRLZQFWpw6crYZoXVFi
        ZmV3vMHng+JvyZJXUwjEnW1HOtUjR9k=
X-Google-Smtp-Source: APXvYqxRBcZQkKKd6HXWIjALWFtrII9r01BSD7FP7VfPl6MUZ+HvnS/FWX6POeMQg2JvXvyVc8QONA==
X-Received: by 2002:a5d:4642:: with SMTP id j2mr22814549wrs.211.1562083142791;
        Tue, 02 Jul 2019 08:59:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id a2sm3813415wmj.9.2019.07.02.08.59.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:59:02 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] x86: Reset lapic after boot
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190627103937.3842-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e4ef265e-ca5d-bee8-1b95-1db0f14c175a@redhat.com>
Date:   Tue, 2 Jul 2019 17:59:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627103937.3842-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/19 12:39, Nadav Amit wrote:
> Do not assume that the local APIC is in a xAPIC mode after reset.
> Instead reset it first, since it might be in x2APIC mode, from which a
> transition in xAPIC is invalid.
> 
> To use reset_apic(), change it to use xapic_write(), in order to make safe to use
> while apic_ops might change concurrently by x2apic_enable().
> 
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---

Also needs the 32-bit version:

diff --git a/x86/cstart.S b/x86/cstart.S
index 2fa4c30..575101b 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -143,6 +143,7 @@ ap_start32:
 	lock/xaddl %esp, smp_stacktop
 	setup_percpu_area
 	call prepare_32
+	call reset_apic
 	call save_id
 	call load_tss
 	call enable_apic
@@ -155,6 +156,7 @@ ap_start32:
 	jmp 1b

 start32:
+	call reset_apic
 	call save_id
 	call load_tss
 	call mask_pic_interrupts

Paolo
