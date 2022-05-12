Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB3852585A
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359506AbiELXca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357149AbiELXca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:32:30 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC83A606D8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:32:28 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id p12-20020a9d4e0c000000b00606b40860a3so3819003otf.11
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gTUkwCFl4eQnWHOmjCkOZ+MxC51lVa04QGhlnVFdjr0=;
        b=KCrUnBzZw0FbOC+bEY7DfMZabUIkT+ejInGoZJeN7Z04sWegXELod3KusB2HhalIi5
         moYjXXYdISshVNhloFqTXBAiiT8l1Lt/qb/MDoDLeRzxOQp6HXpIrH0CmCrG2Rk3QFUa
         D+SRhwry0qQ4fATRknA4vw+r8Xgo7LZzKKZ1XZhAgJ2F7TEBBb5gMElHh25rAwzNlH0d
         GqjCG59VaExNP8G1h5SgoulEBKCV/nWa3vnP3yagHJrYA2//ctSBMjCm529dxDY7MrrG
         aE8JDRNAd69wVZ4eoNGdu6jmJgXq/Znwz0D6cveCP4PIfKzxkWrKdfcTqKxZQTcSOtme
         DAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gTUkwCFl4eQnWHOmjCkOZ+MxC51lVa04QGhlnVFdjr0=;
        b=yDlCRaasN7oyC4yDG37z7JszrARUJPg+CpskieDH55nyfmQosdxRNU405mfEkRXVyV
         JIQIACq29XdDDSWq/3w9Z9Ol8GR6BVRGHlHyPyrHhSOtBwGPX8CrkPAtbfZHa42MDLi3
         EnWZSwD0XOfi7/wgxlBU/Pq3+xGMemJ1axBPNHhXFMVF1wdFlHcL5s45oHTn1bhmSc3d
         WbjLL2QMigFFYDowJBk/X2wICxT6ZTDJSdUSxE93oSqzxucqt/ODp8ZzUdMhcXLFNJ4e
         vd6zO1/NOxUqgV6xm5Ly+z1tP/YXPeJ9s5Uvm5bnlrhKb9cqFOwZK1xTi6TSAp4SM5it
         SFYA==
X-Gm-Message-State: AOAM531axhCcv9dfYuMcbvGfH2V9TqSJ3Ki5GrNFvwwb3EH2qg8axE3k
        hbdmZAzauUmV7b0IjLs3wUbAKQBh8Heo1U3JONvSWw==
X-Google-Smtp-Source: ABdhPJymXYbisqYMcq1fGyKKmDxQzIG71HgmBEDe2A8NT63b1QV/sdpApHnFRtTyoDh1hbCmsjh6HHMT6FeJG8um0yE=
X-Received: by 2002:a05:6830:1c65:b0:606:3cc:862 with SMTP id
 s5-20020a0568301c6500b0060603cc0862mr886983otg.75.1652398347631; Thu, 12 May
 2022 16:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220512222716.4112548-1-seanjc@google.com> <20220512222716.4112548-4-seanjc@google.com>
In-Reply-To: <20220512222716.4112548-4-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 16:32:16 -0700
Message-ID: <CALMp9eRZySh=rLQNUx6fbxDa-6G-vS837tBi=J3HZ9ePTVLa-Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Add helpers to identify CTL and STATUS MCi MSRs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 3:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Add helpers to identify CTL (control) and STATUS MCi MSR types instead of
> open coding the checks using the offset.  Using the offset is perfectly
> safe, but unintuitive, as understanding what the code does requires
> knowing that the offset calcuation will not affect the lower three bits.
>
> Opportunistically comment the STATUS logic to save readers a trip to
> Intel's SDM or AMD's APM to understand the "data != 0" check.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
Reviewed-by: Jim Mattson <jmattson@google.com>
