Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8B338BB1D
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 02:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbhEUA75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 20:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhEUA75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 20:59:57 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE8CC061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 17:58:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 10so13698243pfl.1
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 17:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1tavHnDzQrw/lLSMUPGH3jGAejKlMAvFR++jdzaZBhs=;
        b=d2iZ32fnEnJcaTTHtlRzb1fjeCGYRYFzsXwlWwkAAo3YPU4Nfx5LrVaXPk3Cc31lZv
         QoY5TxGbh2UffgPBnbbkbB8J+6LRT/ITueDJYA6VsidLcKj7y4yQLff3oAx9Mh3h+NcK
         zDdFuJed5ZYyXgqZxv/daBf/v9WiRljmtYjdBYausLsPJbi7mDYXBfBXnWe3cLCiAU2H
         I8NyqcDFRpFZSkC+VdNkmCUd+ADmz3X/clErxXycv6QO/unA08Y6EkV6yTvVoutgUnnN
         fTXwHWezEtA6c1rIbkFvaSHzLjbrLtVD4s1MgzMl2U9RfxUIWV5dj8GLcE4dG+5W45xG
         xZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tavHnDzQrw/lLSMUPGH3jGAejKlMAvFR++jdzaZBhs=;
        b=CLX4BWDTmNUu04WBkKQvCEZ3lOJ3bvY7eg6PDbXCAakID7FydP0y7woghjmCveDpj0
         H3YxJ+BO5t+Vn9PjZ3W2e8D6N0omkXtkJOUscwJXKPGvyytrMQj0zvhZenGqHO/Rbfk2
         wbaBhWfqTVmQKduQ+nKhjWIXV6A6/y5BxtcyfPLVXbzzYBmJmKHSSWkuO6E8pRONyYVa
         VOn2KvbmA9OR4ig9Vno8OAQB9/3d3nqNUiel9V524CkSZrudtogn/emxcJCgXoHJW1Gm
         /jz4O4dzKXna2xmXfO5S+h9iOqgTUBkhal+CULaP3oFZ+3wTcdHO6rJICdTbOy60G2yM
         o4og==
X-Gm-Message-State: AOAM5318Y0gl6z/fqT6j8JJ8kdcmkamtv25fwgFC0rNPMAgAaIcE2WSg
        lI5yhlgqkvfuPQvJp2JQXscU8Q==
X-Google-Smtp-Source: ABdhPJxkdCYZ5U+kC4eUiVA6ITiA5KXG3yq76Aj1sdFHkB54Cv7zHxh/l3qk8ehuHON1468EqQvwhQ==
X-Received: by 2002:a05:6a00:10c2:b029:2de:7333:1343 with SMTP id d2-20020a056a0010c2b02902de73331343mr7365478pfu.42.1621558714327;
        Thu, 20 May 2021 17:58:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s6sm2842634pjr.29.2021.05.20.17.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:58:33 -0700 (PDT)
Date:   Fri, 21 May 2021 00:58:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
Message-ID: <YKcFtmEIdxMjw+G3@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021, Jim Mattson wrote:
> Initially, I added a new kvm request for a userspace exit on the next guest
> entry, but Sean hated that approach.

Hey!  You could at least say _why_ I hated it. :-D

My argument is that the only way to guarantee that vcpu->run->exit_reason isn't
crushed between making the request and servicing the request is by guaranteeing
that KVM makes it back to the run loop immediately after making the request.
Since the only way to accomplish that is by forcing a return up the stack, at
that point we can simply return the "request" directly.
