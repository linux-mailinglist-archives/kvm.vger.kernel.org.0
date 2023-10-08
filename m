Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B2D7BCD9E
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 11:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344568AbjJHJvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 05:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343527AbjJHJvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 05:51:54 -0400
X-Greylist: delayed 1916 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 08 Oct 2023 02:51:50 PDT
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA816BA
        for <kvm@vger.kernel.org>; Sun,  8 Oct 2023 02:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
        Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
        Subject:Content-ID:Content-Description:X-Debbugs-Cc;
        bh=yfP3gGX1yyUl5QHESaZJyn6UY8zszLp7eG3TpVZ56ls=; b=R7/jzwi3LuXJ5LJ7c9HRnnLXZM
        2R3sfTlozkNouwmvSq6uFZ47jk+zybr3DUti0lF9tzJ1tvFRNg1ezjLn/FiU2Ms6433pRlmaoD9Kz
        C7SeQ9JkOV4ZnOSVgj94PMjlS+cdPI7c5VoQMMFDiCuJzDz9JjbQyOIM9qmP6g8yVLEw6ornKl9MB
        FfscDUv6r7IIl8TBoT62NDFsTEINHy89CBFMoAhxfv0jcM/m6cC8xecIMF+ah2bPU+40PEEYt2Z6V
        94zSqOexb/LZ3jbJ/DJN5m/K4BwYuAtW75FS8Y/JngLq5sKZoIH7efLF9Ai+FAcnp3s2eWKaO6npv
        LaKtsfSQ==;
Received: from [2a01:e34:ec5d:a741:1ee1:92ff:feb4:5ec0] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1qpPwq-00Cdwi-NE; Sun, 08 Oct 2023 11:19:40 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.97-RC0)
        (envelope-from <aurelien@aurel32.net>)
        id 1qpPwp-00000007FeR-43ro;
        Sun, 08 Oct 2023 11:19:39 +0200
Date:   Sun, 8 Oct 2023 11:19:39 +0200
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Rob Herring <robh@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Wenting Zhang <zephray@outlook.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH -next v21 14/27] riscv: signal: Add sigcontext
 save/restore for vector
Message-ID: <ZSJ0K5JFrglyJY8o@aurel32.net>
Mail-Followup-To: Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Rob Herring <robh@kernel.org>, Jisheng Zhang <jszhang@kernel.org>,
        Wenting Zhang <zephray@outlook.com>, Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
 <20230605110724.21391-15-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605110724.21391-15-andy.chiu@sifive.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023-06-05 11:07, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
> 
> This patch facilitates the existing fp-reserved words for placement of
> the first extension's context header on the user's sigframe. A context
> header consists of a distinct magic word and the size, including the
> header itself, of an extension on the stack. Then, the frame is followed
> by the context of that extension, and then a header + context body for
> another extension if exists. If there is no more extension to come, then
> the frame must be ended with a null context header. A special case is
> rv64gc, where the kernel support no extensions requiring to expose
> additional regfile to the user. In such case the kernel would place the
> null context header right after the first reserved word of
> __riscv_q_ext_state when saving sigframe. And the kernel would check if
> all reserved words are zeros when a signal handler returns.
> 
> __riscv_q_ext_state---->|	|<-__riscv_extra_ext_header
> 			~	~
> 	.reserved[0]--->|0	|<-	.reserved
> 		<-------|magic	|<-	.hdr
> 		|	|size	|_______ end of sc_fpregs
> 		|	|ext-bdy|
> 		|	~	~
> 	+)size	------->|magic	|<- another context header
> 			|size	|
> 			|ext-bdy|
> 			~	~
> 			|magic:0|<- null context header
> 			|size:0	|
> 
> The vector registers will be saved in datap pointer. The datap pointer
> will be allocated dynamically when the task needs in kernel space. On
> the other hand, datap pointer on the sigframe will be set right after
> the __riscv_v_ext_state data structure.

It appears that this patch somehow breaks userland, at least the rust
compiler. This can be observed for instance by building the rust-lsd
package in Debian, but many other rust packages are also affected:

* Failed build with kernel 6.5.3:
  https://buildd.debian.org/status/fetch.php?pkg=rust-lsd&arch=riscv64&ver=0.23.1-7%2Bb1&stamp=1696475386&raw=0

* Successful build with kernel 6.4.13:
  https://buildd.debian.org/status/fetch.php?pkg=rust-lsd&arch=riscv64&ver=0.23.1-7%2Bb1&stamp=1696491025&raw=0

It happens on hardware which does not have the V extension (in the above
case on a Hifive Unmatched board). This can also be reproduced in a QEMU
VM. Unfortunately disabling CONFIG_RISCV_ISA_V does not workaround the
issue.

It is not clear to me if it is a kernel issue or a wrong assumption on
the rust side. Any hint on how to continue investigating?

Regards
Aurelien

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
