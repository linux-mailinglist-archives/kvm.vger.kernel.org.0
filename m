Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603BE720124
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbjFBMIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235414AbjFBMI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:08:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA891A8
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 05:08:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f60dfc6028so20173945e9.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 05:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685707704; x=1688299704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6N5RSBDUYVnk68nNFO5iJo36EpLGHeNx7EXSoald+6Y=;
        b=vbCorPrw3tzdPss9fLKN2Jev52SLfxSgOQqoKYqSY65ZLrLB+P74BJBRbJMFFlcFg2
         V7Ot2gZjxhSVBPFfbnvwW9yQnphdHhOVXVBSwm4xRuxJ7ex+cLBItdHMh0IW9kYNykOa
         7ioPtcQlOz5kRi11B/L0Pqn/A4DqxsPhLJciZSe5it+Ilkag+UN92q1nxXIWDU/bW0qK
         6n+AgA2OZjG9C+NW4fCSkwSci3fkVM85PC1Jj5pey0miF/c1R/uevQGKz7/OoRj2qh4D
         /Wvth9lpOh+tzo6e1tyb8kTh0oojqqD8BaMgr10akG2ABdWDuoArukXsPjYCzyfN3h4D
         0dPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685707704; x=1688299704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6N5RSBDUYVnk68nNFO5iJo36EpLGHeNx7EXSoald+6Y=;
        b=VnoTY251/X7dam2iqo2Bq7nvCFtM4SfzSLnhhJ2A9Kw+nujQkWGugzEX6JgJQWg1nK
         cvrvuWm6uuAUwS1uR1+OTTYafbRd3ZZaJE1z/5u4Z6MbQavMm/kfFIEHsYmsNAM0W5/s
         Ieoxb78Q4uWifW869cYeqp78J5ZG9KMS73hoT2TyjGusNY1cuLbuuJXtzP+cRd/76GKj
         q5ygWYmHlPQsS8w6jjbwVg5UKk1W1bhp81v80a4eVetfDUbhok/VQhbVNEnRgcA4rR+i
         OSHdnYn56xZgnnLHEvx1HuW48Zq2Q/D892RGdZwdBCiHm1gjgdRweLol01GlMQZRqbAm
         5MBA==
X-Gm-Message-State: AC+VfDy4ibdaet2o/wT+KAg+o10kQ+Jd04POs7ubC4MxAh4ngp4QqDv8
        vw4cIlEHtlpb0ZhgOuwhgsOrAA==
X-Google-Smtp-Source: ACHHUZ7oZo7G5GE5Au7PiQOHzixE8gijDSexUoXlU0n8rp+47guVjLqwzhNWj3i4s1C/PP2kjor3sg==
X-Received: by 2002:a7b:c3cb:0:b0:3f4:c28b:ec88 with SMTP id t11-20020a7bc3cb000000b003f4c28bec88mr1799069wmj.41.1685707704172;
        Fri, 02 Jun 2023 05:08:24 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a19-20020a05600c225300b003f42d8dd7ffsm1784513wmm.19.2023.06.02.05.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 05:08:22 -0700 (PDT)
Date:   Fri, 2 Jun 2023 15:08:19 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] KVM: s390: selftests: Fix spelling mistake
 "initally" -> "initially"
Message-ID: <bbd79f29-f490-4fe4-b5b9-2a0a85c31431@kadam.mountain>
References: <20230602102330.1230734-1-colin.i.king@gmail.com>
 <f0f0587b-5f19-82bd-3d58-bdb89ff59f8c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0f0587b-5f19-82bd-3d58-bdb89ff59f8c@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 01:07:45PM +0200, Janosch Frank wrote:
> On 6/2/23 12:23, Colin Ian King wrote:
> > There is a spelling mistake in literal string. Fix it.
> > 
> > Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> 
> Hey Colin,
> 
> I'm not a big fan of such fixes since they are most of the time more work
> for the maintainers than they are worth and accepting one can result in a
> flood of similar new patches. If this would have been your first ever patch
> I might have considered picking this but that's not the case.
> 
> That being said, if one of the other maintainers choose to pick it I won't
> stand in their way.

I kind of get dread when people ask me to fix a typo in my commit
message.  The drudgery of Sort by thread, Up arrow to the patch, Hit e,
Fix the typo, Add the v2 to the subject, The little note under the
--- cut off, and Hit send.  FML, right?  So I sympathize about not
caring about spelling.  But this is a user visible string.  Kind of.
It's testing code...

You should improve your process so it's easier to apply patches.  For
me, I type "i" to review this patch in context.  Then "ESC:q" to leave
vim.  Then "ap" to apply the patch.  It's six key strokes.  Anything
more than 10 key strokes to review and apply a patch is not Web Scale.

regards,
dan carpenter
