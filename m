Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E53E1ACF8A
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388403AbgDPSW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbgDPSW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 14:22:57 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A39BC061A0C
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 11:22:57 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q22so8951018ljg.0
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 11:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2AJXNXiAB6W7rFrZCbALmh4q22OnU6lxgAbw+PmwEgQ=;
        b=hUFtTadKXcXXZANsLiCgBHmKbBdeVv8Xd/U9RCsajjI7V6EJuCjOtn+CbPJdjc/xva
         6h2/j8V9Ae0HPsio/JBZ2eGra2qcUlfJ4xdOWGb50zuB1xHwCxKLoRoeq8tYwlcejLsp
         NqMnkJTgH8tAQTGld18HhnzEdvJvVwDKM4XTXIiFKzr7vNwXg0uxNghgii7A/oHHaRF1
         LNJ/gtsy1Lpkiv36b131vRDt0BNtBrBhicBvdHkCQwNCyUksmvsxaKGHg+m44jGh09rV
         RiplMj5St9ZxaoldEOZtjr/WQiFs6MSy5H8HU2DcrSnURL3Ro5jzdWE382JXs1RlSerS
         5e/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2AJXNXiAB6W7rFrZCbALmh4q22OnU6lxgAbw+PmwEgQ=;
        b=FIUCP1RI+HAfDp5ghWbx2F2bVEBJCsouV9MMk65SoT1SSzq/Dd4qSzAss08vkuKMOI
         GaF51XDoqIc+ddur/gb2rpCFKNSxu6ZFtihUfWNSh1cT7E+ygCu0qQ8bbDG7vEf78zcl
         mqaQV+mKlQCk/l78jrMc5HEos/GcdFWQ+vUx8A2cIo7GpT0c9ggZCwluQHvEmai5q9dL
         MlsxmimYJBpZNE1gOK4dpX/lmRAto7IzrnRjkFvwZ8SFoSYjOJGUJJuDnwGZjm5fs7pD
         Gjq4EhlNJg1CIEVrkQTz3hszOcKP4ItXd7bziUWeCx5LSMR2tdPafVXiPP7ctwXtbnB+
         3qkA==
X-Gm-Message-State: AGi0Pua/jFiwps4QCH1t4j2PruaUIywyzJAU4HZjuebTCvKGxv+VA397
        1KFzutpqFJZo/VikT4f6IZ5Lp0sQYlzqSA3rrbJvnA==
X-Google-Smtp-Source: APiQypK0MEj34nx4Jc/G+PCSOsEFrhP4zYZGsPQoecMSH5BAWsCiXKq7EajCs66JATef7G02EdUM6SBth3c8rR/1fgg=
X-Received: by 2002:a05:651c:200c:: with SMTP id s12mr6736693ljo.30.1587061375466;
 Thu, 16 Apr 2020 11:22:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200414214634.126508-1-oupton@google.com> <20200414214634.126508-2-oupton@google.com>
 <CACwOFJTzdCAq1hVfPLfTFzH3QAEJSXKJxEy6yf7ku9GqxB-=0w@mail.gmail.com>
In-Reply-To: <CACwOFJTzdCAq1hVfPLfTFzH3QAEJSXKJxEy6yf7ku9GqxB-=0w@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 16 Apr 2020 13:22:44 -0500
Message-ID: <CAOQ_QsgQSf_KPMJOiu+NZZf0KmgwDADXy36mqLhBB_Lbke3JXg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: test MTF VM-exit event injection
To:     Peter Shier <pshier@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 5:05 PM Peter Shier <pshier@google.com> wrote:
>
> Reviewed-by: Peter Shier<pshier@google.com>

Gentle ping :) Paolo, I believe you've already taken the associated
kernel commit for this test.

--
Thanks,
Oliver
