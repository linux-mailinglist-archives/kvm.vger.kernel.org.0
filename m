Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4BC78F1F7
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346950AbjHaRbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjHaRbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:31:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E58E67
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693503049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zk4ElXSbDyoeIWWxswUZjXtDcjddTI//a78p4yp2fJM=;
        b=hnKyjGm1Lhc2vvtFGRikhrqElpu2NA4zUN5OBiTG9Mbv4hq3tTaWSE8N6Juss0mlmgUh5o
        weGr0LuWu34R4qVTHUlk0OChAdcSJxfzzalJtODjG1ph/GY3T84XpGOmy/CeW2g6jckmnf
        KVwid6ycT4gufOblcHB2MJDTzro8Qfo=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-DIkfXJxMMe2oLDlIpyoGTw-1; Thu, 31 Aug 2023 13:30:48 -0400
X-MC-Unique: DIkfXJxMMe2oLDlIpyoGTw-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7a2b3c1fb6bso412653241.1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693503047; x=1694107847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zk4ElXSbDyoeIWWxswUZjXtDcjddTI//a78p4yp2fJM=;
        b=dc5dxeBXfrqptzUyuOp2QEgNRfPqBLyEUzKqq3B5nKkUTPDOEI5N6eNP004UvDgKzc
         I3k8DHutWmjY9UJO5fYq193nshaYJBz9DMAgfR67BONRBMdVTc3++WTG7nbWJArNGYEi
         gAZNMnSPDef9t3Pd9Ith0x0L5sRjmuzEdJhhEMw7gcCetTbI2wdYpUtlo+ezpiEaWrXC
         ipOVdBvbbYJcl2A9cffJMDZrfHhjVCLAkU0Z/usx+6tW5EkVxzSMvB7Lia2Hci61HZTJ
         zLm+NW7wNK2wKbNlh9SQHKj1o9H87u/mQAOAZHAzAx4+QKXsb20zW+Zy4if6N5RloT+L
         DE5Q==
X-Gm-Message-State: AOJu0YyWCgasIsaRAEFYawTUp4R5F+akC6p9a8idn2PCWl65ZjpmcjLO
        anNy/xihygPErrlHSa8oi5PKhOagEdAA8DA3UHqFRAKC5xk4v/m++NoE9sK9YmF3ehq/ToauU/Q
        oTDnw58PiJJ3gxgbPgdP56DRnObg1
X-Received: by 2002:a05:6102:11fa:b0:44e:9e04:bfdf with SMTP id e26-20020a05610211fa00b0044e9e04bfdfmr283201vsg.10.1693503046957;
        Thu, 31 Aug 2023 10:30:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPiDorpO7ycfqnlThKi8Nc4VYAE45f+3YSq3G0ZrlZJgGFcXnGWS0cXwVEoTR3s2Ddmi2XoWneMsZpqZ+aNi4=
X-Received: by 2002:a05:6102:11fa:b0:44e:9e04:bfdf with SMTP id
 e26-20020a05610211fa00b0044e9e04bfdfmr283182vsg.10.1693503046720; Thu, 31 Aug
 2023 10:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Aug 2023 19:30:35 +0200
Message-ID: <CABgObfYxjEiHARA2yCep7ck5snVYC1Ckh9prp3Y8J9xyRea8cw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 pull requests for 6.6
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 2:06=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Adding a cover letter of sorts this time around to try and make your life=
 a bit
> easier.

Appreciated, but not particularly necessary. :)

If anything, I would prefer to have pull requests during the
development period if any larger features become ready, so that
conflicts become apparent earlier. Not a huge deal, we can sort out
the specifics when we meet at Plumbers.

Paolo

>   [GIT PULL] KVM: Non-x86 changes for 6.6
>   [GIT PULL] KVM: x86: Misc changes for 6.6
>   [GIT PULL] KVM: x86: MMU changes for 6.6
>   [GIT PULL] KVM: x86: PMU changes for 6.6
>   [GIT PULL] KVM: x86: Selftests changes for 6.6
>   [GIT PULL] KVM: x86: SVM changes for 6.6
>   [GIT PULL] KVM: x86: VMX changes for 6.6
>
> There is a trivial conflict between "Non-x86" and "MMU", and a less trivi=
al one
> between "Misc" and "SVM".  FWIW, I recommend pulling "Misc" after "SVM", =
I found
> the conflict that's generated by merging "Misc" before "SVM" to be terrib=
ly
> confusing.  Details in the "Non-x86" and "Misc" requests respectively.

