Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D72E730223
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 16:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbjFNOoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245629AbjFNOjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 10:39:54 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD11E4D
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 07:39:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-570022400b9so9468677b3.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 07:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686753592; x=1689345592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/AH6uPigy9LtuLTFoZ1Kn9i9/l/hz+EtqMRDMoYV1fo=;
        b=epo0PuzWzte/OOmmEpqmE/GWTr1GBMpsc1uSar8XtkuWWX/h9QhWhJgdlFLOdQWDm4
         nNboqSPgDKhsqcs67Drod790hyCrPEwzGFMcvYUJXAM9E/WftZVCGCbunkPA3Av41LHa
         DdJY4bj497l6ZNJHK73iTGuFjrsVmAHXB4U4RGMqsaxqjtyNdXHtPXdJcqrO60NOmFnq
         5V9pYmzbrvOOoAAm8XHHxQfghMU8PCTCf6RJV03ztC8Y8iFv8Jeo0OHRR6+Yf2AAP9YH
         vaEos6bb26U7EF2SaGEYXOzJCyFY99k0e0e/p/jHbI2uHooKhGF61Oy0ZJ/RsMFSy8uH
         MhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686753592; x=1689345592;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AH6uPigy9LtuLTFoZ1Kn9i9/l/hz+EtqMRDMoYV1fo=;
        b=h00R8qDI84zIqttWXXG7gtftqkyFm6RidUVRRuMORJY2pd/c291HvP4CNJQrL3du+j
         MTjqceXqRYAofLwwWS0ytBqi33k9TJR5T9pkkbmweMkDzfysSPAjaiYG9y7jxwnEWN31
         iAo24sI1MGGmwtQ79mX4cwVZKUdbuxCACyg6cNm5jcVySnh2u8NkfeJ4lGnCHpQiyOK0
         xtK0mCiOzVhZ474Pj7Pm/yYlWBNUoY5tiTNxf/gSfs+6c7nS+O8KTq+HJSGaQwYG6tf3
         67UuzDIBonOfwwUmb0q4ylqjI+4OtoBLCwqzF+Op4QCDLzRJbQ7jDKR2FuVL1tb4hq5b
         z/dA==
X-Gm-Message-State: AC+VfDw0TLSvQfLXK/Nyf8xmpIdr6KBV3llzR6RWL/gy7TQeCr/+IPL0
        zBMX0jXyXIK6KBx1HaJKIfczkv4tGiI=
X-Google-Smtp-Source: ACHHUZ5C7ugUcDxAC4fyHl3lyT/DeF+mM58NhmS8t+GMlBXVtTje+z3/5W4u/dYfKlCTI+LfGB9ZWiVGr5o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ec0d:0:b0:bac:faf4:78fd with SMTP id
 j13-20020a25ec0d000000b00bacfaf478fdmr289336ybh.7.1686753592568; Wed, 14 Jun
 2023 07:39:52 -0700 (PDT)
Date:   Wed, 14 Jun 2023 07:39:50 -0700
In-Reply-To: <20230602161921.208564-2-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
Message-ID: <ZInRNigDyzeuf79e@google.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't put trailing punctation in shortlogs, i.e. drop the period.

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> hva_to_pfn_fast() currently just fails for read-only faults, which is
> unnecessary. Instead, try pinning the page without passing FOLL_WRITE.

s/pinning/getting (or maybe grabbing?), because "pinning" is already way too
overloaded in the context of gup(), e.g. FOLL_PIN vs. FOLL_GET.

> This allows read-only faults to (potentially) be resolved without

"read-only faults" is somewhat confusing, because every architecture passes a
non-NULL @writable for read faults.  If it weren't for KVM_ARM_MTE_COPY_TAGS,
this could be "faults to read-only memslots".  Not sure how to concisely and
accurately describe this.  :-/
