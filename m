Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639D8668F60
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 08:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbjAMHmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 02:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjAMHmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 02:42:07 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7371A839
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 23:42:06 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id i9so30095196edj.4
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 23:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nsdFs6pzrliWUStfNOl1FM9T1mI6Xi1uicxIBR+DHR0=;
        b=bxg1JS8fp+9+/+7/09+z6yzY2UJpMRs52IaTtZs4uChAsUtbFr3/5xjnZ2k8aPLFrI
         EC7tEE24pKzHsigOYR9z4BFbxC3/iEJXOK4WREzE3Z5Tcyny0ZpGcnLUIEMwUotRlpcw
         lZM6FwML+lEJGVYZbFzIBaHIBU3qh2tCXZauGMuuEutvJfiZlhEMsdpTJct0SRkdCtng
         sarYsRN7TiRqDEFGwgYGG3cYJ9RZYwCGxxBJASK4jBlhtMTWrFsmRl8cyIlCAj3WdBJj
         Lav4o1Cr+KDqYPabyg43TRivHDBRAqpf8rmkN2uM/3MbrhNm/ZyVGTnJiuNAXW6Dlo1s
         exyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nsdFs6pzrliWUStfNOl1FM9T1mI6Xi1uicxIBR+DHR0=;
        b=b8YMhkRbzXIN0fMS4JwHtekbRTNTg+U8NJGUttqt4W1R0goTp8oKK5DhDbyjy1gzSS
         XgA7DVNteMxysathPVXr+s4x4wtwSy58lYyyzA1mJ8Jo/7kpRjf8uLJaXHyvzESOcaQ4
         +f2f/LfRZAvac3zOw5zFhDdn5clC63f6E88UPFd7PfacKIbppGgp5v3eLVbzhBfCQzEj
         RwjfcAL53SoO2JLZS5A/+jSeUXo0bmJ1MGfoiWzH5OwmCRPlGT1fsHAEwyMnnpOlVKsu
         kvuhwA+/vAlFolAd1ksmi14JMOP2EYPmex7KWzmkijJLERUcvh5l+bGAGfTVctrjeKeA
         JY2w==
X-Gm-Message-State: AFqh2krFqO+gCxO9KP9dFN+h8T2dQdMra8KkVOsKmXzsflBX/5Dt4cUV
        DNfGHrXcleTmln8TTiucfcr8d9BTiatkdfpO
X-Google-Smtp-Source: AMrXdXtm2abt8YC1BnrO9ZablHgd7dzlkKrmOBXbgyyxB4FSNCxnE4tz+rAhG7qm5jh2MQ0HncQ+xQ==
X-Received: by 2002:aa7:c393:0:b0:499:b604:4de6 with SMTP id k19-20020aa7c393000000b00499b6044de6mr14363452edq.25.1673595725444;
        Thu, 12 Jan 2023 23:42:05 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id l15-20020aa7c3cf000000b00467481df198sm7904083edr.48.2023.01.12.23.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:42:05 -0800 (PST)
Date:   Fri, 13 Jan 2023 08:42:04 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Atish Kumar Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Eric Lin <eric.lin@sifive.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 04/11] RISC-V: KVM: Modify SBI extension handler to
 return SBI error code
Message-ID: <20230113074204.p3wmeer2o3penunt@orel>
References: <20221215170046.2010255-1-atishp@rivosinc.com>
 <20221215170046.2010255-5-atishp@rivosinc.com>
 <20230112110444.jjbmgslr6dspxwbh@orel>
 <CAHBxVyEyMdk+vQ5wTgOF56UJs-zLtkVixDxXquTjoLyV6Vj21Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHBxVyEyMdk+vQ5wTgOF56UJs-zLtkVixDxXquTjoLyV6Vj21Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 10:47:13AM -0800, Atish Kumar Patra wrote:
> On Thu, Jan 12, 2023 at 3:04 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Thu, Dec 15, 2022 at 09:00:39AM -0800, Atish Patra wrote:
...
> > > +      * and forwards the error to the userspace.
> > > +      */
> > > +     if (ret < 0) {
> > > +             next_sepc = false;
> > > +             goto ecall_done;
> > > +     }
> >
> > Shouldn't this ret < 0 check go above the "Handle special error cases..."
> > block?
> >
> 
> Why ? I thought if an extension handler has both utrap updated and
> returns an error,
> user space redirection should take precedence. Let me know if it is wrong.

My thinking was that utrap cannot be trusted if the handler returned an
error. The handler may not even have had a chance to set it before hitting
the error condition. IOW, we should check 'ret' right after the handler
call. If it's < 0, then from the caller's perspective the handler didn't
execute due to a KVM failure and it should be reported to userspace.

Thanks,
drew
