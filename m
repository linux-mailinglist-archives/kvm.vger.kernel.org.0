Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F59535438D
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhDEPq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbhDEPq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 11:46:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5395DC061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 08:46:50 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so803691pjb.4
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QygMyjm+J0x5pjrOmHZ6gF+M96kFAIe6R/VarziNp/M=;
        b=OnXfc9yRpkM4+WnqQi5E2oQOSDzicyd0zgEoQaF99v1hTcmLrA5YrfuhW2McMWq8b0
         jyKceUvcJUav2KnCvhwlvnYxm6/kLIqtPAL0bec+S5GLUoQoxm+Dm/2mT149gQE+9jgS
         Fn4zl0KjjEDhW7SVKqNlu6UA4lLZg3MJ6cW7AM4k+I4e2H2qSV20TR4gZqGBOyuLVLEg
         twE4yuBMAojdf1LY4jo3wr9jQj/yck85t7tQFa8Z76U9O5Q+YjQ5WZhPrR9woWuuhjAv
         5iT5poQJovhMGBfY564uULtUuK2DaFmvKSFPrQnI5CpwrUZ+kUHrJN2CoSU+LqKcrFtq
         2BZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QygMyjm+J0x5pjrOmHZ6gF+M96kFAIe6R/VarziNp/M=;
        b=fEnNxwV9PzQMqXZBgZCPqNk3ZiZJOuLJmC/vGWOmBg6SnE4553w1YTQNEMHes4vuc7
         aTZ0uWOHZ9UitGwFJIBV1YGzR6Y+lzFo5p6JT1YgKqAkTyaadGqarU3KogV9f0i9dwOQ
         aJ4Q4o0ayDvhhR1qpJo3SOL99LJ3Klg5SGKQaeH6UEmuQ0UBI8OEUrvc9jqLBmRMBpG+
         6nq0iiY23NG8WBIznzjYPEI/oBir8Uq2hpiIz25K1LU/7VM66v/U1Wk2sPEjcB39CgLs
         /h/qjW+xxTKSmLRl6HuXkxH6gB4j7olHCKnZGRgSMBU0WFKkb+CkTsSe5MZ+FfM3PKkv
         0xtw==
X-Gm-Message-State: AOAM531T8+USe8dZAVZSQQbxTFqguPCKDewWfpwdVtb7NAwznkumkUhi
        ALfojNOAQYqMG+WdTSUHs6fUZQ==
X-Google-Smtp-Source: ABdhPJzqI809ED+WwBgP+wM5YxIa2c7laGs9c4ukQ5Jp8rfxZA07T58WUgBLlUpboQXi8u4mX4um0Q==
X-Received: by 2002:a17:902:d706:b029:e6:90aa:24e0 with SMTP id w6-20020a170902d706b02900e690aa24e0mr24900130ply.42.1617637609836;
        Mon, 05 Apr 2021 08:46:49 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l124sm16313789pfl.195.2021.04.05.08.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 08:46:49 -0700 (PDT)
Date:   Mon, 5 Apr 2021 15:46:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 08/12] kvm/vmx: Refactor
 vmx_compute_tertiary_exec_control()
Message-ID: <YGsw5UPoA/OpOIok@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
 <1611565580-47718-9-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611565580-47718-9-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Robert Hoo wrote:
> Like vmx_compute_tertiary_exec_control(), before L1 set VMCS, compute its
> nested VMX feature control MSR's value according to guest CPUID setting.

I haven't looked through this series in depth, but why is it refactoring code
that it introduces in the same series?  In other words, why not add the code
that's needed right away?
