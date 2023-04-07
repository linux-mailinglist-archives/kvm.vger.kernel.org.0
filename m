Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA5D6DB526
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjDGUVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjDGUVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:21:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33C9BDE5
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:20:45 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ix20so40865749plb.3
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GF2EsCjK1quwKdTdKH+hb7VQ5K5FIifTcNs2bwyi8h4=;
        b=HZDR0PYcAPGTUn6ycwov7K7qZyZBNQJEykJYiaRRpJt7EODRBNP+lOGisFUX3R9ulK
         5zeky7DnphgaHQJY621uwlrVrwG89LMQzRYevJY4KYARpivVZFLRMgRrOyJ5KX0k9FIa
         8eMe/+eSZeGEtwgiHvnNTtj+mOMDPMvExC8n28fbLdiL+q2iPJHUUpUnj5TAmuou0bwW
         EwgrRNQ/pQOUbMARl89x7LR97pb8ZTdusULYc1i8/wnXpXaoIQWhuSfPbqJfH9T8BWg4
         ypoz2CyMGMBKzEAhtU2z1uoo+ft8V822fxrUB6jXUr67d/7mjh4Zk7ymLFyV9uPhFWbC
         ee8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898844;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GF2EsCjK1quwKdTdKH+hb7VQ5K5FIifTcNs2bwyi8h4=;
        b=gzNXPdtpbJbAoC+8VOTN6VAXTR8HOT1gacvSTQNHuxYEdVyhXHLNwJJRQ4P+CiXY6c
         CXu9LLpSo72ESVT30TbjlvH3Aa8//5gA/kZasvyWBh1nvgaBqauzgqRfDKTPdhTcPMtY
         LJ8pETcVlJT0o0YRjX3KIkH4DxNF5Kx3Uz3jLusVnftDCFdVdm8OXMxSswjYUEsLYk7R
         35nnHYOenbpXwHxtyVzf8sDG7WHtN2JI6+KcOiU+Xd8VXXFBpaz72UJYodLaZrPTg8i5
         JbYzVvq49CqsxqUjBuaSY3AOgpHPJPscRa79eHaz9IfXDWhBhd0ZIlrIeao+LPDJ7k8s
         8P3g==
X-Gm-Message-State: AAQBX9eF19dRNnr78MPLzSa+ZMzmstC49ElmDxVTusTfkEpJChjoZ+x+
        MVKkkBWDqpwlgqhkO6XHMnFI3w==
X-Google-Smtp-Source: AKy350YIpW6sudkOvhEeWA5SBtIX2kd4A2gSAOTFhvjYrrcHNr4RtgUHcs0swZuHt4L7NoRaBNDxUg==
X-Received: by 2002:a17:903:2448:b0:19c:e666:a678 with SMTP id l8-20020a170903244800b0019ce666a678mr4772488pls.50.1680898844533;
        Fri, 07 Apr 2023 13:20:44 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902b10100b001a505f04a06sm2584449plr.190.2023.04.07.13.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 13:20:43 -0700 (PDT)
Date:   Fri, 7 Apr 2023 13:20:40 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: More cleanups for Hyper-V range flushing
Message-ID: <ZDB7GIm6/nYrgsYR@google.com>
References: <20230405003133.419177-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405003133.419177-1-seanjc@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 05:31:31PM -0700, Sean Christopherson wrote:
> More cleanups of the code related to Hyper-V's range-based TLB flushing.
> David's series got most of the names, but there are a few more that can
> be converted (patch 1).  On top of that, having Hyper-V fill its struct
> provides a decent improvement to code generation, and IMO yields a better
> API (patch 2).

Reviewed-by: David Matlack <dmatlack@google.com>
