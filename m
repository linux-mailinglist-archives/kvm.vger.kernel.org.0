Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13C540E7FC
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350006AbhIPRnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 13:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355727AbhIPRmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A715EC08ECAB
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:23:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f129so6666762pgc.1
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=os8rPPCaF89PPiVrnE71sKF7gfEFVZ9yV2+yV9yUHR4=;
        b=Qb7LcVXCEjjeuIheMzTtc2GBg9gKLbCPL2bZUc8zBpPNURrWsv9Dgnvee8UtwAWpM2
         KqT/003vxruXr7KvESOWEYGCW8cDiHRUrvna29ezRiXEL0TG94mmXTtGX1qDpQheicNK
         EJpOb2fAMBJcuXde7O4ul41Iesw4VTEKh6ryNr188Zt3lxJIhepqVgbGqltAtB8l7cJC
         x+Lwo12+goZKaiUbtn4AKpOiy98M1xmhxYd9QVM7NtVIHyWIpiL2gX+CfyqquAh+t7D9
         fYg7i6oEdhc/SOq5/aTlsBUyZuH+LbjSZnyz/W7186frV3GulKYIBjerp9S0M0sKpBB7
         NMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=os8rPPCaF89PPiVrnE71sKF7gfEFVZ9yV2+yV9yUHR4=;
        b=hy0kYn0pjYg4jEccQ+UFs8EgKA/cldyoUYn1dVpWZkIo24h8aZGKzZgDxZcwnN0QR7
         amXPQWDo9JIeqJCvAfHuhbjQQU78NLl1rBu2mk88RDar52ckZrpdV9BuwhknTJg/XDnP
         ajX6v2Lidye4zofBtEETgBrdjrrrhRzNDvKl/a790Kx8yMqPmFHdUwwzOyGkucTtUFSM
         YakDu8F9DPRaS9yALCAWJ1Ci3EixwAnLTUcHPa2KcyDzuORkBMYL0n/4l/iZZHX0SQ44
         5gJASvNIEcmX/sE7IawPL0WL+l5Ia/AFxjKXNMZZwWsOrn1mhIV77K++g3eDgFSGNOJg
         UWZw==
X-Gm-Message-State: AOAM5316Sl+FqHSc6MG3yvfyxnwWmUly/9LwxqrRAXigZ2K8W1uIK5rI
        ynSU4WkQhGtVa09RYgxf3C89mQ==
X-Google-Smtp-Source: ABdhPJwl7DlrIO8koo0hDyar+Y2gWKmCVex6gaphG2oB4GTxCDsWv80YTpH1lwK43hPlXQ/YtKlphw==
X-Received: by 2002:a63:b349:: with SMTP id x9mr5643759pgt.139.1631809438005;
        Thu, 16 Sep 2021 09:23:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 19sm3761871pfh.12.2021.09.16.09.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 09:23:57 -0700 (PDT)
Date:   Thu, 16 Sep 2021 16:23:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: Re: [PATCH v5 2/4] KVM: x86: Get exit_reason as part of
 kvm_x86_ops.get_exit_info
Message-ID: <YUNvmbtmgRkhLguj@google.com>
References: <20210916083239.2168281-1-david.edmondson@oracle.com>
 <20210916083239.2168281-3-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916083239.2168281-3-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021, David Edmondson wrote:
> Extend the get_exit_info static call to provide the reason for the VM
> exit. Modify relevant trace points to use this rather than extracting
> the reason in the caller.
> 
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---

With the From: / Author thing fixed,

Reviewed-by: Sean Christopherson <seanjc@google.com>
