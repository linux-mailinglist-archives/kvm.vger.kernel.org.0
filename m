Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542BD31545B
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 17:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhBIQvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 11:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbhBIQtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 11:49:06 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D35C061756
        for <kvm@vger.kernel.org>; Tue,  9 Feb 2021 08:48:26 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id t29so12247168pfg.11
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 08:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EXWPNsJpzjeuuDLRADZAeXF66eXi4rpWz4gB0/VueD8=;
        b=UAo2z8RW2sUzhpxfvKVzs61wPj1iZPXoJoXRXzUDgCNcdBibf8MEcYu5Af0gCpHpvI
         TI/zD8rzqYDV5GrORkB4lba0AVUO8eoF8lzbwi3+H3JpmGeVdQ7+7gZKcuKhdm9oKHRy
         nPxbvjf2eg3/jD9FcEw25SyJVuYvsYuilMZIcQYMohc7srVeF1ZINP0pd6UFIRm2BMhE
         iNJlnUPiS216Sjb1ecvqw/uTk8XwhvHK+3ddOcfgi9wGfZwV7lCeXutPG8oTqTYdPmLl
         zRMnLKLxHq2+yQha5wMKHOJm58SS/U1XHRQDjeXCMcjvbGvqmLzBlAF0wcdI2HclUa0Z
         ZC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EXWPNsJpzjeuuDLRADZAeXF66eXi4rpWz4gB0/VueD8=;
        b=L6wvRG1u/pd1jzvtLh6LFUZPR5bAL8IQ+Q+Q75bTC7yNEm0rvahKVnodIl0h55Q0EI
         z3G2rEJqIQeITrt5le0Uxj0H4WP2Yq1DvyeMfHl+G49TKOtWOBl0QxIqITVPod/ORFyo
         9n2EeAGGtWkKrSDNic0n9eMMAI/hFphUSF8Eqt1qOt4efezeGF3Jr/5xAleIJMns5Ge3
         uial+CW/2iUVCyK4a/H2hUka/AAVWsGYxg2V0XeQHb/sRPnyg7kaNJpRhowXSjTWty2v
         uhEcdVyYP89+Z+lgID8VbYrLPAaJtVbTNl3T5B0h9jLZUQTxa8B8BkNvlfo13nJFTAK3
         809g==
X-Gm-Message-State: AOAM530LJAwX1LWek87iw/ZWrmy420cK/h8cO4P1cp13QqcbsQp+P9WP
        TfHIJRSD1kYSG6kVy0jRauVX5Q==
X-Google-Smtp-Source: ABdhPJy1L6WfOh2elLxCyP+ILOVp79ZszE5ugkqMwsqdbbfiyOhx7aL2+M9IToFYpPtaMH2vHQQd+w==
X-Received: by 2002:a63:f405:: with SMTP id g5mr22946290pgi.276.1612889305403;
        Tue, 09 Feb 2021 08:48:25 -0800 (PST)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t6sm23139205pfe.177.2021.02.09.08.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 08:48:24 -0800 (PST)
Date:   Tue, 9 Feb 2021 16:48:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
Message-ID: <YCK81Zcz++PfGPnw@google.com>
References: <cover.1612777752.git.kai.huang@intel.com>
 <3c1edb38e95843eb9bf3fcbbec6cf9bdd9b3e7b1.1612777752.git.kai.huang@intel.com>
 <b9e8a9a0-6a53-6523-4ea8-347c67e7ba86@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9e8a9a0-6a53-6523-4ea8-347c67e7ba86@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021, Dave Hansen wrote:
> On 2/8/21 2:54 AM, Kai Huang wrote:
> ...
> > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > failures are expected, but only due to SGX_CHILD_PRESENT.
> 
> This paragraph broke my brain when I read it.  How about:
> 
> 	Add a definition of SGX_CHILD_PRESENT.  It will be used
> 	exclusively by the SGX virtualization driver to suppress EREMOVE
> 	warnings.

Maybe worth clarifying that the driver isn't suppressing warnings willy-nilly?
And the error code isn't about suppressing warnings, it's about identifying the
expected EREMOVE failure scenario.  The patch that creates the separate helper
for doing EREMOVE without the WARN is what provides the suppression mechanism.

Something like this?

  Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
  the SGX virtualization driver to handle recoverable EREMOVE errors when
  saniziting EPC pages after they are reclaimed from a guest.
