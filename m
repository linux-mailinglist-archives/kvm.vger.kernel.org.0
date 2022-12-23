Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C28F6553DA
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 20:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiLWTb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 14:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiLWTbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 14:31:55 -0500
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A81F9E6;
        Fri, 23 Dec 2022 11:31:54 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 2BNJV0jN3004810
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 23 Dec 2022 11:31:03 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 2BNJV0jN3004810
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2022120601; t=1671823865;
        bh=8U3L5z1AFR94Ur4HvgFf3agP7oLPg6/0b60n1Rc2c/4=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=hGys46pcf8iXwpubOAabv5YFxZB2dujq1N3fwxUDjpx1gwXM9NKRY2gfjaXKEENxR
         N2JMsyOYoDRuKID3Vf4f5wlNVfCnwa21fhkcu3QquU5uItaNJ8l6Z3Q6fSHNIovYqW
         WV14O2GaxSdGWCI3s0qp+jfqAUWoajIAMCvUQ06dk4MoizxQYMBfEsilHRYt3HktQo
         M964NM6veTBPKPkeQQEQXWfP/mt0M/lEub0JOwrzoMO2pjU+Z/Y/ejTeNdCZEyupLK
         6Fryj+ZlS+WY1Gl3FR99z3xljDm+HX4f60/z63j5ityGw4d2VMr37ehsuykH/02MVg
         tTXyGnr+RKYcA==
Date:   Fri, 23 Dec 2022 11:30:58 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "Li, Xin3" <xin3.li@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [RFC PATCH 22/32] x86/fred: FRED initialization code
User-Agent: K-9 Mail for Android
In-Reply-To: <Y6RXCJNn8xyl7g7u@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com> <20221220063658.19271-23-xin3.li@intel.com> <Y6GELyEJeKY3dEqJ@hirez.programming.kicks-ass.net> <16972e64-7d7b-ad8c-f8dc-6dcab69e629e@citrix.com> <Y6GIN5Uf7Qd43A9U@hirez.programming.kicks-ass.net> <BN6PR1101MB2161C51C6068026D9C442460A8EB9@BN6PR1101MB2161.namprd11.prod.outlook.com> <0D72CCA1-A0B6-487B-A6B9-7341020D28A2@zytor.com> <Y6RXCJNn8xyl7g7u@hirez.programming.kicks-ass.net>
Message-ID: <77C92705-B15D-4680-8587-CAEB48BEDDA1@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On December 22, 2022 5:09:28 AM PST, Peter Zijlstra <peterz@infradead=2Eorg=
> wrote:
>On Tue, Dec 20, 2022 at 09:44:33PM -0800, H=2E Peter Anvin wrote:
>
>> Right, this is one major reason for putting #DB/NMI in a separate stack=
 level=2E
>
>But with the IST they each have their own stack, with FRED they'll share
>this small stack=2E

So make the stack larger if you think we need it=2E You still end up using=
 less total stack space with FRED=2E
