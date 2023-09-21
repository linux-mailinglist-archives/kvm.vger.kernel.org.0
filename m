Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C337A90DE
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 04:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIUCZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 22:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjIUCZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 22:25:55 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB2BD3;
        Wed, 20 Sep 2023 19:25:49 -0700 (PDT)
Received: from [127.0.0.1] ([98.35.210.218])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 38L2Ojrq2878666
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 20 Sep 2023 19:24:46 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 38L2Ojrq2878666
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023091101; t=1695263088;
        bh=WciaewRbFVCG7f/TWCqOhh4NlX/euw7ehl3BKDv4D2s=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Ljqz95c2+2ctrUrqDTYh4QJqwX6aq8mwwAySkJYOLB/rmPNr+SnxWAYlU/KQSCT5Y
         tz1ezsYWqK0Q4cbXNch6WmSJ06yICbg3IW6efg/D3UscvInNuY+tdrl12AD0aOeABS
         jJnQKYPibz2ODD7CuZvST50wrsGNzOQdvKs4ffKVf6+Dzir4Me4tyjJ9yIDffI8iep
         PiaHLNeUMu9OkEdAJ0K0iskn+vI9N9gg/LhElcG3QQu2b49nd1vPLUf+lmlguTs+9v
         aCY/LfiHWkB5ORkGwlNjhb+7FcMKMnOnZzBWQVPbPpuDO2ZZDvqBIwYYvhyazgjB9h
         NhSAU3+MJhZIw==
Date:   Wed, 20 Sep 2023 19:24:43 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Li, Xin3" <xin3.li@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 36/38] x86/fred: Add fred_syscall_init()
User-Agent: K-9 Mail for Android
In-Reply-To: <87h6npuuk9.ffs@tglx>
References: <20230914044805.301390-1-xin3.li@intel.com> <20230914044805.301390-37-xin3.li@intel.com> <87v8c6woqo.ffs@tglx> <SA1PR11MB6734C02FFB973B2074EC6CC8A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com> <87h6npuuk9.ffs@tglx>
Message-ID: <4578F690-1501-46C3-9048-5AED97EAD001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On September 20, 2023 1:18:14 AM PDT, Thomas Gleixner <tglx@linutronix=2Ede=
> wrote:
>On Wed, Sep 20 2023 at 04:33, Li, Xin3 wrote:
>>> > +static inline void fred_syscall_init(void) {
>>> > +	/*
>>> > +	 * Per FRED spec 5=2E0, FRED uses the ring 3 FRED entrypoint for S=
YSCALL
>>> > +	 * and SYSENTER, and ERETU is the only legit instruction to return=
 to
>>> > +	 * ring 3, as a result there is _no_ need to setup the SYSCALL and
>>> > +	 * SYSENTER MSRs=2E
>>> > +	 *
>>> > +	 * Note, both sysexit and sysret cause #UD when FRED is enabled=2E
>>> > +	 */
>>> > +	wrmsrl(MSR_LSTAR, 0ULL);
>>> > +	wrmsrl_cstar(0ULL);
>>>=20
>>> That write is pointless=2E See the comment in wrmsrl_cstar()=2E
>>
>> What I heard is that AMD is going to support FRED=2E
>>
>> Both LSTAR and CSTAR have no function when FRED is enabled, so maybe
>> just do NOT write to them?
>
>Right=2E If AMD needs to clear it then it's trivial enough to add a
>wrmsrl_cstar(0) to it=2E

Just to clarify: the only reason I added the writes here was to possibly m=
ake bugs easier to track down=2E There is indeed no functional reason=2E
