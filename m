Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AD76831E6
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 16:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjAaPxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 10:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjAaPxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 10:53:44 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23FF16ADD
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 07:53:43 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b5so8255871plz.5
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 07:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8BDBGIr020TIEN48KHoXszHSY7JH31zE2b6DhwjqkpU=;
        b=i0jigBhmeRjaAtvW2bVUaQPHSOXnmtp6KW5DRBVBoMs9M95X0qKfuKWydeztA7qQ9A
         +PqS3GEUcHUGwBfRKP3Zuz3rfg+thRbu4mVBTTUBXhpE9TUVjx24IUQzns0scPtIXuMT
         ctgHAVgpKcpJ7by5c58aOPLIilAVT9b9knMJz8fqgIO1SLTBHQ7f8kLcc5QbQOpKEC9Q
         qJFBMGogqJC3mGYSXcXl1IxvbUJfJ6CHTl5z6jH2in9+Gl1URvuhstI5fQt6nPIRDK0n
         wBCdfAIvDjt2WfX6v2ee8EjsAimhl2K90y6zivnNcHzOd78Q7m/lJtG+6nBvZHCHKZmh
         iFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BDBGIr020TIEN48KHoXszHSY7JH31zE2b6DhwjqkpU=;
        b=C5t0LkQP9Sji1z1VW0wiixH2fz+POphowNRgBCAJQV9YtfJUfoblG6EC1Gr57gJauI
         eRrKq305iTtaRBqqDlhi/t9JT9P1G3cD0v8RsfnPnwyoZrKcPeh7UFMt45RsXF1F3oAg
         +Au+sToo47KNJmxxxsRK5DGZb8CBfK0R3tODfo98H9I38J3T3kkrWvTJqdAhcLjGxviL
         r4o/LoRf9LTpJ5Yoky/eDDOSRXAGO+UBHdmJs76QHjhV+j67+h3sXl/PHANUe8fv3CAW
         ZmeMH2NfCJ+N60PUzAFlE83AGgnysd174efzGx6EJK6FAKuMsgwOFY35NFfSkPm/eyzg
         btYg==
X-Gm-Message-State: AO0yUKUeUYd5rcXe3bVJmWEupWb+CUG4A6Lqx+kumuGF/ZLNADXShcx1
        HKe1dH/rczzIMh/3ldsqcApv2xD8mgp4jeVmJNw=
X-Google-Smtp-Source: AK7set86Spbju15zAbisK2mmq3j8WKEdenghpKFRQltXbuwmg9z/EBPdC24x5DEU09pf9f5AKKLB0w==
X-Received: by 2002:a17:902:b686:b0:191:4367:7fde with SMTP id c6-20020a170902b68600b0019143677fdemr1307314pls.0.1675180423267;
        Tue, 31 Jan 2023 07:53:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902ea9100b00196768692e0sm5338448plb.86.2023.01.31.07.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 07:53:42 -0800 (PST)
Date:   Tue, 31 Jan 2023 15:53:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9k5g5jYA/rjIwUj@google.com>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
 <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
 <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
 <Y9jX9AKYP8H34wGI@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9jX9AKYP8H34wGI@8bytes.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023, Joerg Roedel wrote:
> On Mon, Jan 30, 2023 at 09:30:38AM -0800, H. Peter Anvin wrote:
> > It's somewhat odd to me that reading %dr7 is volatile, but %dr6 is
> > not... %dr6 is the status register!
> 
> The reason is that on SEV-ES only accesses to DR7 will cause #VC
> exceptions, DR0-DR6 are not intercepted.

I don't think that is technically true.  A _well-behaved_ hypervisor will not
intercept DR0-DR6 accesses for SEV-ES guests, but AFAICT nothing in the SEV-ES
architecture enforces that behavior.
