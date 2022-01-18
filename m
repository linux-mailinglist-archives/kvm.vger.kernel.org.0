Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39665492F7D
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 21:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349263AbiARUjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 15:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349143AbiARUjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 15:39:12 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E15C061574;
        Tue, 18 Jan 2022 12:39:11 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p125so297912pga.2;
        Tue, 18 Jan 2022 12:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTxSIYtF/qhDMdpcunv+R2Pnv7mrcydD4DvIe4qQgBA=;
        b=XzNVA7WFscHIr9quBbwN1Zl6DlOEBX9F8WsDR4fZuQmtO7dSeFEckqOuxbRK5Dbr36
         /eNURLliqpELZFheqowDPzNq72XN2bbp84c7+2gEmZWBXHzwINhnbQmHL+COLhW/mH7B
         sEyyYr0KSen0K0Oz8LuUJAMgc5YGn6FdzO6XUxUA0ZHD/46rOBRY6iZqcfjk3s4c3c+G
         tQ0FJvOpkvJ1cM8BKRmRfnNY0v9QN+Kor7sdjGPNwfcPoNNyO9VuyPm3JdHZi95ha43F
         kAYsOqWFk/ykFHxFzIQuyr5djbFrIif7ZEGmKHeNwzi3xNaqHdgLcnaN11LGGvahgN+J
         qjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rTxSIYtF/qhDMdpcunv+R2Pnv7mrcydD4DvIe4qQgBA=;
        b=4Z/dvufav4Wo9c1JRIIAkMQDTpAoFOh3UJI7ch95hsgeASuC+KgENvTnnMHMP+5PY3
         nXS3eJDaWSFAkKZJikinZtbr3KLTC8oRAZdaJIuSSeIEPV3KHV/h6baBjQ5/e7J0AZjs
         YSB4Ep1Agj8odLY6N8rSCdPu7vVQszFoCV+ok/R/VulrT4P9Yc3uJmgx6ggzje9Dg0BW
         LKPt1tGswR5J+DMDBPJLe3DlMxPwj9nza66ZBToYcQ0rj8RcZ6lS0fbW4Ipq7ZdVhE3e
         aTDGUYzPXswFO/HcmuQTPRlfVCZDsi3PXm5FJQRH0ky/Y99hkNFarI/bgHo+aojU3OoH
         lI5A==
X-Gm-Message-State: AOAM5312fx/7fo+T9KBwLSH9zgDl2p5dakka8tUwdf3dWaHiVt6Hvt+8
        kC6oRAtTFP66A9DLGzHdoyM=
X-Google-Smtp-Source: ABdhPJyeiRPViIFqLAMdX5NCXcv8RFZDx7ydr82FV18KzIXzXluRnjCoqA20Vyi5zu46O1Q7GFBlZw==
X-Received: by 2002:a63:191a:: with SMTP id z26mr24598864pgl.593.1642538351256;
        Tue, 18 Jan 2022 12:39:11 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id y64sm15227654pgy.12.2022.01.18.12.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:39:10 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 18 Jan 2022 10:39:09 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        pbonzini@redhat.com, seanjc@google.com, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com,
        kvm@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Message-ID: <Yeclbe3GNdCMLlHz@slm.duckdns.org>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Jan 18, 2022 at 12:25:48PM -0800, Vipin Sharma wrote:
> Automated tools/scripts which delete VM cgroups after the main KVM
> process ends were seeing deletion errors because kernel worker threads
> were still running inside those cgroups. This is not a very frequent
> issue but we noticed it happens every now and then.

So, these are normally driven by the !populated events. That's how everyone
else is doing it. If you want to tie the kvm workers lifetimes to kvm
process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
exit wait for the workers to be cleaned up.

Thanks.

-- 
tejun
