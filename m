Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0E70EFE3
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 09:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbjEXHum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 03:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbjEXHuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 03:50:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF5C93
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 00:50:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 647072243F;
        Wed, 24 May 2023 07:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1684914638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rvDxc996bWvS0b16mE9F71bfGKG1BiGQdYN+RnxVi20=;
        b=dRjX6YHdAr6Oz3bxNtuCewCuHWH/dKVcCRujoPkqOLdm1zrlK08Oqn/dSMqeGNcPwTpleV
        QZvcM/qUrTyxnwn1y6UXdkAXjsrmsD8LXwEvnGZ1zi/dGiBGp2gqHo0TtktBIIABWpI++Q
        lNHwWySaqT7J0jdn62RKGvrO8Yf8rmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1684914638;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rvDxc996bWvS0b16mE9F71bfGKG1BiGQdYN+RnxVi20=;
        b=fAYPQMGCH0hE9LJ7NAU43b9T50qoRGr/Aioe0Bz8GX130LN9gTmM9HcS0bN4aS+cmx4JwL
        VbPIv9dnK2fCM0Bg==
Received: from hawking.suse.de (unknown [10.168.4.11])
        by relay2.suse.de (Postfix) with ESMTP id D21882C141;
        Wed, 24 May 2023 07:50:36 +0000 (UTC)
Received: by hawking.suse.de (Postfix, from userid 17005)
        id 9B0444A03A8; Wed, 24 May 2023 09:50:36 +0200 (CEST)
From:   Andreas Schwab <schwab@suse.de>
To:     "Arnd Bergmann" <arnd@arndb.de>
Cc:     "Palmer Dabbelt" <palmer@dabbelt.com>,
        "Andy Chiu" <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org,
        "Anup Patel" <anup@brainfault.org>,
        "Atish Patra" <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        "Vineet Gupta" <vineetg@rivosinc.com>,
        "Greentime Hu" <greentime.hu@sifive.com>,
        "Guo Ren" <guoren@linux.alibaba.com>,
        "Vincent Chen" <vincent.chen@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Albert Ou" <aou@eecs.berkeley.edu>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kees Cook" <keescook@chromium.org>, heiko.stuebner@vrull.eu,
        "Conor.Dooley" <conor.dooley@microchip.com>,
        "Huacai Chen" <chenhuacai@kernel.org>,
        "Janosch Frank" <frankja@linux.ibm.com>,
        "Qing Zhang" <zhangqing@loongson.cn>, eb@emlix.com
Subject: Re: [PATCH -next v20 12/26] riscv: Add ptrace vector support
In-Reply-To: <eb61b8c5-4c0a-4d64-b817-235db848995c@app.fastmail.com> (Arnd
        Bergmann's message of "Wed, 24 May 2023 08:32:27 +0200")
References: <mhng-f92fa24d-c8bd-4794-819d-7563c1193430@palmer-ri-x1c9a>
        <eb61b8c5-4c0a-4d64-b817-235db848995c@app.fastmail.com>
X-Yow:  My BIOLOGICAL ALARM CLOCK just went off..  It has noiseless
 DOZE FUNCTION and full kitchen!!
Date:   Wed, 24 May 2023 09:50:36 +0200
Message-ID: <mvmzg5udv77.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mai 24 2023, Arnd Bergmann wrote:

> On Wed, May 24, 2023, at 02:49, Palmer Dabbelt wrote:
>> On Thu, 18 May 2023 09:19:35 PDT (-0700), andy.chiu@sifive.com wrote:
>
>>>  static const struct user_regset_view riscv_user_native_view = {
>>> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
>>> index ac3da855fb19..7d8d9ae36615 100644
>>> --- a/include/uapi/linux/elf.h
>>> +++ b/include/uapi/linux/elf.h
>>> @@ -440,6 +440,7 @@ typedef struct elf64_shdr {
>>>  #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
>>>  #define NT_MIPS_FP_MODE	0x801		/* MIPS floating-point mode */
>>>  #define NT_MIPS_MSA	0x802		/* MIPS SIMD registers */
>>> +#define NT_RISCV_VECTOR	0x900		/* RISC-V vector registers */
>>
>> IIUC we're OK to define note types here, as they're all sub-types of the 
>> "LINUX" note as per the comment?  I'm not entirely sure, though.
>>
>> Maybe Arnd knows?
>
> No idea. It looks like glibc has the master copy of this file[1], and
> they pull in changes from the kernel version, so it's probably fine,
> but I don't know if that's the way it's intended to go.

Yes, for these types of definitions the kernel (as the producer) is the
authoritative source.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
