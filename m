Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED08677E2F2
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 15:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245658AbjHPNou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 09:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343497AbjHPNop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 09:44:45 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B46AB9
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:44:44 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56463e0340cso9833718a12.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 06:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692193484; x=1692798284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DfKYErMF9EpbQzj7prUXo+VJmVciw7snB0QH6nUOx0c=;
        b=NDH2iIAX5DXaSyyrW5vcJU1QHoAqNAj4qeESAvSaADuuHnudkS9qxr/pAW3gJDLDB/
         Y8HD7RVNAVj7RYXVev45WRJLuPblUswv6kJAkrkMQeL+Go0rSE+vPx7xDOdMzrRXJHJc
         JmVYCDx+Kqnw2tEIYYerdWe53Qpl68ZgKPeF6SkNFSJ7+95bNJMQwtv6XhB0fx6B7q6Y
         R0yqPE9GlRqP3Lv1nvpXA0edRxQZMYyIR5v7wLbffnQ3i2FcH+UK4Ad1HDT7EFEjgweb
         6Q+SJlNnSDG1pKxb8LjDW300bUJPbnkFy3F7iJir1VF8MgiNUbWj/NuXF0k6t/a+BrdN
         C0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692193484; x=1692798284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DfKYErMF9EpbQzj7prUXo+VJmVciw7snB0QH6nUOx0c=;
        b=FwysnCUk2K5zCp7T5eOqud1dmNtOElyy3BvByqJYO82S9qWOfO8/NZ8ROhBsT019CA
         +rBDrUEeyor/izQaiwEp6Q8dWKYvv5GhtYJoVS5sfQ485bGi6zet90BMTcQtCvMpcPDF
         NIKP9lb0pcVMUSfDm8VAJVa4ATCp+mwfmFVcY+/bu8FhTgt56ZF0A7uj/WfR6oMhKVE7
         wfGmQbM0Jc5G32EDG4BT//K+0Uv+EBhFmEOPeVGvqaXQteUeUfnZkVtYRvzCBf7Jjgqy
         7aNY3zkXlRviGoKNXuJXKOCiUrSmPbMhF6xXdtF7YQUSGjogek3HhZiHlvSEN+RBRqdF
         Rj5A==
X-Gm-Message-State: AOJu0YwVci7u1bhbzjrC9HmVBjAUX1Qz9Y2XwoQnLNreaQjctDfSIJp8
        qwftfj4a7EMUFCIIhJ3+Xp8ymv4hjzo=
X-Google-Smtp-Source: AGHT+IGd4fYUCjDU25ByWI8JrVrsykv5J74DbQAeMl2oHpahXX74KE6wec7C7Du6Z6kirONFwDHU56tHcMQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:77c7:0:b0:565:8280:eac5 with SMTP id
 s190-20020a6377c7000000b005658280eac5mr370096pgc.0.1692193483950; Wed, 16 Aug
 2023 06:44:43 -0700 (PDT)
Date:   Wed, 16 Aug 2023 06:44:42 -0700
In-Reply-To: <20230816063531.rq7tyrvceln5q4du@yy-desk-7060>
Mime-Version: 1.0
References: <20230815203653.519297-1-seanjc@google.com> <20230815203653.519297-10-seanjc@google.com>
 <20230816063531.rq7tyrvceln5q4du@yy-desk-7060>
Message-ID: <ZNzSymgZqozT7Tno@google.com>
Subject: Re: [PATCH v3 09/15] KVM: nSVM: Use KVM-governed feature framework to
 track "TSC scaling enabled"
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
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

On Wed, Aug 16, 2023, Yuan Yao wrote:
> On Tue, Aug 15, 2023 at 01:36:47PM -0700, Sean Christopherson wrote:
> > @@ -2981,7 +2982,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >
> >  		svm->tsc_ratio_msr = data;
> >
> > -		if (svm->tsc_scaling_enabled && is_guest_mode(vcpu))
> > +		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
> > +		    is_guest_mode(vcpu))
> 
> I prefer (is_guest_mode(vcpu) && ....), so I can skip them more quickly LOL.
> but anyway depends on you :-)

For this series, I want to do as much of a straight replacement as possible, i.e.
not change any ordering unless it's "necessary".
