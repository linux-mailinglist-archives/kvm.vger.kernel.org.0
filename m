Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453AD74213A
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 09:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjF2Hn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 03:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjF2Hnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 03:43:41 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C7EE58
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 00:43:27 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3090d3e9c92so498382f8f.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 00:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688024605; x=1690616605;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wLLErFSUtOGXgZAftNwrlB6BAvovlkaWFenRZZkK7xA=;
        b=H6K7sm1OPC8OU22IkDa37xQ5MY3UFmxyWw5yb7Aa+5uBDYmSPseC7bL5XmVR/wA+Iq
         qMdIrXP47WNLoDIEZguXLWQZSZSUCjW/xkgY1l4mo+dkC+gCj3CGTgyS443KOr3dvY9+
         LwdrqDp3fRuw1q7v14jaBAMPD7kAYbWaAclExQJK0WiEj+xKBRqFFIOwukt6rUsqGwaM
         Z6yH6ry7KfFwOUY3g57qMQ8w/quEJcW6ync2L4nxdi34WtwOxVmFmaq3hYlD2MMm/AoA
         FGpQH9nuEHDWRpMrILLLm44+l8jMzQq3PZOvCf1CJpDn0dXmnWDyYrXHiA2q3m74uRvY
         1NAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688024605; x=1690616605;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wLLErFSUtOGXgZAftNwrlB6BAvovlkaWFenRZZkK7xA=;
        b=FJciRE76KuIxvgxmgLKyAIPp8eY6PIwIwTw6GjoVH/VLF1uUdXVn7QPujhmQlCTrR/
         NwD7iNEPOjWCnqKstoLgpI+brn7cSU71/qzE3zLbJvfhgiNCTTEuH/sZr2ax7bZ09hdg
         bFb4+WXe0AYsoxs8JNMBkvQ+hCUlfFfsUk+CZhg3RgULBrfhZwgSpgGEHE299ZEh73Wl
         qYC3rImeE+PAJAqTO0rfxV9HzdTLymyQrVTWYndqbGWlN0IEmSMs2RHGxetrYkauZ8o6
         wls/QiNMrKlQ50NP5Nd1i1BT9Kd36zYHohy6E9WwTmVKJznGXGi7fLH0CT4OOtSlghbc
         HdEQ==
X-Gm-Message-State: AC+VfDxlQ/queh2y0gXAnW3IiXIA9mGgC0NYw+LZUQl/HrnRA8CFUsqF
        1uLtJAra/NTrrp3D2/i0ylz7whi3i68Ml+Lwqb0=
X-Google-Smtp-Source: ACHHUZ6i4MZpbQFu2Ur6Jyq0YT1CxcdWOFr1/o+IZb327NkmYzVHkBau7R/mO1EUEztj/pICFvhvOA==
X-Received: by 2002:a5d:5345:0:b0:313:eec8:a9ed with SMTP id t5-20020a5d5345000000b00313eec8a9edmr14290457wrv.57.1688024605651;
        Thu, 29 Jun 2023 00:43:25 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6542000000b00313eee8c080sm11608655wrv.98.2023.06.29.00.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 00:43:25 -0700 (PDT)
Date:   Thu, 29 Jun 2023 09:43:23 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH] .debug ignore - to squash with efi:keep efi
Message-ID: <20230629-b82d3fae013a121287f0aa70@orel>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628-646da878865323f64fc52452@orel>
 <20230628-b2233c7a1459191cc7b0c9c0@orel>
 <848CBDF7-51AB-4277-9217-B43B566CF60A@vmware.com>
 <1377A285-1B0B-4D35-9C01-FE71EB5760FB@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377A285-1B0B-4D35-9C01-FE71EB5760FB@vmware.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 05:33:52PM +0000, Nadav Amit wrote:
> 
> 
> > On Jun 28, 2023, at 10:30 AM, Nadav Amit <namit@vmware.com> wrote:
> > 
> > 
> > 
> >> On Jun 28, 2023, at 1:22 AM, Andrew Jones <andrew.jones@linux.dev> wrote:
> >> 
> >> OK, I see the .gitignore hunk in patch 1, which is good, since it
> >> certainly doesn't need its own patch. I'll just ignore this "patch”.
> > 
> > Embarrassing… Will send v4.
> 
> My double mistake. So I see this patch was not supposed to be sent, but other
> than that - you should have the series. Let me know if anything is wrong
> (as otherwise I won’t send v4).

The series looks good. I plan to queue it, but was hoping to see some acks
from x86 and maybe ppc people first.

(I had to switch to this email address because I can't authenticate to
the mail service used for my @linux.dev address right now... Hopefully
that'll get resolved soon.)

Thanks,
drew
