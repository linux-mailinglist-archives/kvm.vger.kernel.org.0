Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525F522CC6F
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 19:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgGXRmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 13:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgGXRmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 13:42:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419DBC0619E4
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:42:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so5674566pgh.3
        for <kvm@vger.kernel.org>; Fri, 24 Jul 2020 10:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U50zr+VshRe9mYuWVqDq7CNgzIqrkIfFylK6XexbWKE=;
        b=esEqwYwiF2m2i9Gp06Apxexvboy5U9ul9g68MueBSxJcjBjMQGdvHGFDnJJQap3xxR
         XhM4nWcCt/BWatQmNXYxfbnHeLB+cwvvzLxCD3ArVYYAeiHf4g3zESPK5T2qMVj5A4ft
         EhlkS/H1Gn677G/SsxoYiePReMo8rMYLkY4yQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U50zr+VshRe9mYuWVqDq7CNgzIqrkIfFylK6XexbWKE=;
        b=TL1QIn6vn0oJkoFapGz6ByqqbCw88D4y3oA1ALaguaQqamrQg2dxYHXdVN/jqfzTMI
         sU9FsjiPGIvhZgsr5B19ONxMkV1TT0J7F9BPXz0W75FbbIYiGLgVrJVqCl8EMwOx6ZXf
         qF+VQm0/TnOJIag9EnzhTerLnJj0mHn1/rlQQv0N32MK+xuYwd3++2V2bws+fPDzk/bQ
         CDVMYIXTgz+1Hdf2Ya8WenRSsoe91iLjj2ETMgWJt6/ZHrdorUAQ1qjX+mFxrN1CZaZW
         sJeuwcwjnRYPPVRh7tdQ227HayA4TO+NdHcNCWum4ysKmMXfk1AYhBQcojTmhyFxGEKH
         6/vQ==
X-Gm-Message-State: AOAM530zM3TrQBOLEjpHOAa8Htwe35Kc6hEDElTgtnNUtpGuK9gVbnTj
        di01hWnVpF0bSIPXkt1AQ9Za3g==
X-Google-Smtp-Source: ABdhPJxtKpo45I9LuQoJECycYCtMUIABAY1HmaYIM7v7qjODgmc1ompAK4OP3e0iHW9NrkeIeAJbeA==
X-Received: by 2002:a63:fe0a:: with SMTP id p10mr9318212pgh.255.1595612572909;
        Fri, 24 Jul 2020 10:42:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g28sm6772558pfr.70.2020.07.24.10.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 10:42:51 -0700 (PDT)
Date:   Fri, 24 Jul 2020 10:42:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 32/75] x86/head/64: Load segment registers earlier
Message-ID: <202007241042.D3E8FC382@keescook>
References: <20200724160336.5435-1-joro@8bytes.org>
 <20200724160336.5435-33-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724160336.5435-33-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 06:02:53PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Make sure segments are properly set up before setting up an IDT and
> doing anything that might cause a #VC exception. This is later needed
> for early exception handling.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
