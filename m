Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240B677625B
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 16:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjHIOX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 10:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjHIOX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 10:23:58 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED91FC2
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 07:23:58 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-687071894eeso4759934b3a.3
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 07:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691591038; x=1692195838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9zpyW03eshaeH9Sr4sGjLZGjabDdV1ZBUVVrLztPH90=;
        b=zbGQ0bWUYfp+uCOYSAQRh3kYYI7a3f8k2jI4RUJKQAR1VFdACzIqDnnJA5QRzNnXpD
         dmUD9ISCPaRLENpCaYx4lZ0qXn/Z8CLewnhT/AlOdrRk2+ofucc5Zwh8j2a7j3HpIoZ0
         qO7NcEg5YafZfGmcdbAGWAo3Rbo0egtiyusakVgVf0VMLLgzq9ZW8R/WwgPTXLlK3M3B
         WVxCkB5bLeT6GtRQjA72G0ynae2knnaY+3Gbs2ENYHjN5UA8jCctVPQKTYVLygxSd4mp
         EMrYOH3az2wxwLzgm9tURx/X0BxHRePaZhv92cmtqge+li5rnO9ZB4X+PbouoFFSiAcM
         /TTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691591038; x=1692195838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9zpyW03eshaeH9Sr4sGjLZGjabDdV1ZBUVVrLztPH90=;
        b=Qh3H2lMgAletbgLLVGvrsDGdZDlDaNwDkFgDZB0GbYvgUiAANPIbKxqWldCDm7ExUt
         GhG3JrcxxPmZML+wSk23BmvoFDCpsjcWh00XzLbLeuvSRgD3U0/9yruD9acfYQBO9e4t
         6fUpmOZgOri5Ohk5HDmo3FJikXCeAdDLoIXpv1KoJmUNH3/Y+8MBbkWF5uzihY6MRMc5
         rT4tfCydXnxcao23Uem6Vn5L71Lg24AhNcQtgNwEYNpNWjNinGk9MaUsYZZP7Q+Yw4wY
         qTah32K9a9AVe/06QkSgzrlQoTXTsld7cd1wSSJ9HX48/4xPbRwiKq9wAeoxgUdNUMo4
         IxGA==
X-Gm-Message-State: AOJu0YyYc4IIs0LLQoEfnS3FbvNs6q4r9HfoHewN8Ro9f+hxPt++3Lzr
        QZAW0EHgvnky+UTLTTfa41Zq4MhdTew=
X-Google-Smtp-Source: AGHT+IH4ryL5887Vn/UApVbkk4fujhQ/hVnjb96u5LiJPUr37eC4Iuh3VjN7DAXdLDW/56x9JYiIDfUBdK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1398:b0:687:4a62:f49 with SMTP id
 t24-20020a056a00139800b006874a620f49mr313679pfg.5.1691591037991; Wed, 09 Aug
 2023 07:23:57 -0700 (PDT)
Date:   Wed, 9 Aug 2023 07:23:56 -0700
In-Reply-To: <c9a1a5cc-7e84-e887-f4e3-8396cc8ce494@oracle.com>
Mime-Version: 1.0
References: <20230808233132.2499764-1-seanjc@google.com> <c9a1a5cc-7e84-e887-f4e3-8396cc8ce494@oracle.com>
Message-ID: <ZNOhfMgeBnRwwXDX@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Set pCPU during IRTE update if vCPU is running
From:   Sean Christopherson <seanjc@google.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "dengqiao . joey" <dengqiao.joey@bytedance.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023, Joao Martins wrote:
> On 09/08/2023 00:31, Sean Christopherson wrote:
> > Fix a bug where KVM doesn't set the pCPU affinity for running vCPUs when
> > updating IRTE routing.  Not setting the pCPU means the IOMMU will signal
> > the wrong pCPU's doorbell until the vCPU goes through a put+load cycle.
> > 
> 
> Or also framed as an inefficiency that we depend on the GALog (for a running
> vCPU) for interrupt delivery until the put+load cycle happens. I don't think I
> ever reproduced the missed interrupt case in our stress testing.

Ah, I'll reword the changelog in patch 2 if this only delays the interrupt instead
of dropping it entirely.

> > I waffled for far too long between making this one patch or two.  Moving
> > the lock doesn't make all that much sense as a standalone patch, but in the
> > end, I decided that isolating the locking change would be useful in the
> > unlikely event that it breaks something.  If anyone feels strongly about
> > making this a single patch, I have no objection to squashing these together.
> > 
> IMHO, as two patches looks better;
> 
> For what is worth:
> 
> 	Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> 
> I think Alejandro had reported his testing as successful here:
> 
> https://lore.kernel.org/kvm/caefe41b-2736-3df9-b5cd-b81fc4c30ff0@oracle.com/
> 
> OTOH, he didn't give the Tested-by explicitly

Yeah, I almost asked for a Tested-by, but figured it would be just as easy to
post the patches.
