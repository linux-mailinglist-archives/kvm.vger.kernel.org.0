Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97CF760246
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 00:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjGXW3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 18:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjGXW3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 18:29:39 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D2C10D;
        Mon, 24 Jul 2023 15:29:39 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6bb07d274feso3750457a34.0;
        Mon, 24 Jul 2023 15:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690237778; x=1690842578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0fbW2p4gExV+dRAH4t+fQv6KZU5wysFEgmsKG6RQE3U=;
        b=eqCyZWOg1GYQ3NPxLmzBkap7N3a53wSFZ6D3WxNgefFC/Il/js96yWptfpIw1LnBdZ
         L/5QQwbRc7wR5+wu89/sT6o2li0tdybpCZHKjSuSH7+soU0MeKyR8MH30vKrXSjNol0M
         MpgEEkYILch9P2MMHlkCIHIi5VS31ZmePmvtLiYVTvXFjpavhAW+bkEYu3ZWBtpQtdZt
         oo7QLftbpo5ZnS0fqfrUqj1aE1FAymjX7lV/pReTUs0fimo6OX5ZW8lLCNDZNGKpgOIX
         EXHoCh/Qh5fxlQk1YHQSDSma4WFOYWN/gyI9YvcuitWR7WjUl4RxLzgEsBY/xVR00asP
         /NUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690237778; x=1690842578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fbW2p4gExV+dRAH4t+fQv6KZU5wysFEgmsKG6RQE3U=;
        b=Q/TGh73QgQick6jeJzbEE1hNtV1ZhUMKw5fBOClx9q+YlZmqo2FOxcpaOBr7Q8/6Pj
         cjkyh3Fkx0YEZcsYY95jqpGDmuMxRVLI8TEka/AYe7DDj3lYAt6ZN6FzyoVA7uZA6IMU
         Mxq6e5SK+K1ZOVEd/obTKFBYYQ/+Z7++75kDsx04RmK70J/i28pV9j1VcWCGTm33b6d1
         hQthR2t5/PzQlSnl63f3p/Kt4I3RvWwmbW53oGlKmxJGHO+qSHEGcqxf/IoMvrOGtppO
         v9omTCw4GszAZ9rGiYEbLx7akmIjyGE02ZE74NVLIy5d7VzXcFl/3LALDb+noxQ4VzxM
         0ZEg==
X-Gm-Message-State: ABy/qLYgYdgTJj+l9lvk1XADFRacAV3rhQcrro3cqmS3ryce10AX6lIh
        g3JBG6zV8To3/8fD2vaR4m4=
X-Google-Smtp-Source: APBJJlHHs/SGtYsJN4fftGcBqaBKEpdC4rKS85jQmFKzy/LFiWWoWopc4eUju8HSoEqe4QgZWH8a2w==
X-Received: by 2002:a05:6358:9212:b0:12f:213:b558 with SMTP id d18-20020a056358921200b0012f0213b558mr6623406rwb.22.1690237778128;
        Mon, 24 Jul 2023 15:29:38 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:9d8f:da31:e274:eeb5])
        by smtp.gmail.com with ESMTPSA id q11-20020a638c4b000000b0055b44a901absm8991765pgn.70.2023.07.24.15.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:29:37 -0700 (PDT)
Date:   Mon, 24 Jul 2023 15:29:34 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Message-ID: <ZL77Tt42+ZI2BAv5@google.com>
References: <20230721201859.2307736-1-seanjc@google.com>
 <20230721201859.2307736-15-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721201859.2307736-15-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Fri, Jul 21, 2023 at 01:18:54PM -0700, Sean Christopherson wrote:
> +static bool kvm_is_svm_supported(void)
> +{
> +	bool supported;
> +
> +	migrate_disable();
> +	supported = __kvm_is_svm_supported();
> +	migrate_enable();

I am typically very wary of the constructs like this, as the value
returned is obsolete the moment migrate_enable() happens. Is value of
"svm was supported at some time in the past but may or may not be
supported right now" useful and if it is then could you add comment why?

Thanks.

-- 
Dmitry
