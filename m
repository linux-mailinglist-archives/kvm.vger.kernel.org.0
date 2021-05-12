Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4B37EBD2
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 00:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244619AbhELTiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 15:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356339AbhELSbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 14:31:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A7FC06134E
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 11:30:05 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 69so8339758plc.5
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 11:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A9Ko3pdZ2rzlbkM7/cmDj6gAjJyg0TCPkB31sRwB94Q=;
        b=SCPTjQq21pubdJzA4mbow+5m4BINvsWq7DaYb+6AaSj9Vt9LhUc54ErMfNGYYz55pp
         Nk8DHKCaYf6Q/voUgWCOXWQ2zkn/pYI1ZPb0//27/6LRSCXdifCUQGQ5kF+QdAuYvicT
         wEmSL1zptBSbxVCJVDIvfhQEtGMyPJ7jf29O6JRN7RbjY+pJEoeJJmoNto1tFdI9cULP
         cBrTwXFpwSTHYnldmBylufqMrTdQKhFKlJuLOFPOF6hvKKvM4gP85kCA8eoXRbW1FvEY
         Edc7DsOjNnxVP6M8gbwL5xA8tEgQ+fphRVT4G2blldC5j8xydhLyFE4XFq0PJUUTI9Pd
         lrgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A9Ko3pdZ2rzlbkM7/cmDj6gAjJyg0TCPkB31sRwB94Q=;
        b=KxkhiLHhL+t8cqgSVPh2bn+uMmHlzEG8SUaJ/etNJoeFKBacoJ/cfHxe1uSOAjWa/m
         gtVbu10lI3/p8KQTDYAa5A8U1pYyjx+xG5kgRjoWakk2bE4a/5aBxxTfimMbNcDY2u0d
         h6UtN5s83iWENNijrQYwEn2JW3BBZ2TEuqjh6xSNuTqvlQeKapQTOoQ/G3s3hhIifGjY
         FyJM1QHizuHAKWKj2b4Bqm5lNB3cBjTfQos2tkqTDlqWCc+blOFGr0r35QoUof8WKMRk
         Qisie7fVPkKmN+oM+R/dJWnFXjWCLrR4O4lwypJ2ewQ+UkkrfUK57lVtxJsC0Quzu1s2
         rYAg==
X-Gm-Message-State: AOAM530nPq+f+gzVEppdIKyDOZRWmwfIYJ3ImLqIzS595qgabd5idxCT
        RWrHSq8tPtNGzbyUOF81dbC5grbtCgwdYg==
X-Google-Smtp-Source: ABdhPJzPlsyTR3RFYdM6Zji76Li2ZzVRSp8j7bNHTH8EQb8SvbfHM4Nt601Tw2YhAJWIWryHDYYpSw==
X-Received: by 2002:a17:902:c943:b029:ee:8f40:6225 with SMTP id i3-20020a170902c943b02900ee8f406225mr36388987pla.52.1620844204432;
        Wed, 12 May 2021 11:30:04 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w14sm446642pff.94.2021.05.12.11.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 11:30:03 -0700 (PDT)
Date:   Wed, 12 May 2021 18:30:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/3] KVM: nVMX: Move 'nested_run' counter to
 enter_guest_mode()
Message-ID: <YJweqOAxMITSmKs2@google.com>
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
 <20210512014759.55556-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512014759.55556-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Krish Sadhukhan wrote:
> Move 'nested_run' counter to enter_guest_mode() because,
>     i) This counter is common to both Intel and AMD and can be incremented
>        from a common place,
>     ii) guest mode is a more finer-grained state than the beginning of
> 	nested_svm_vmrun() and nested_vmx_run().

Hooking enter_guest_mode() makes the name a misnomer since it will count cases
such as setting nested state and resuming from SMI, neither of which is a nested
run in the sense of L1 deliberately choosing to run L2.

And while bumping nested_run at the very beginning of VMLAUNCH/VMRESUME/VMRUN is
arguably wrong in that it counts _attempts_ instead of successful VM-Enters, it's
at least consistent.  Moving this to enter_guest_mode() means it's arbitrarily
counting VM-Enter that fails late, but not those that fail early.

If we really want it to mean "successful VM-Enter", then we should wait until
after VM-Enter actual succeeds, and do it only for actual VM-Enter.
