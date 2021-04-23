Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADB369676
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhDWP5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 11:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWP5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 11:57:03 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8535AC061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 08:56:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p16so21468936plf.12
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 08:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5WzQlXC727GizG8RyV51VxxCJok7TVZDl6kolV1YY08=;
        b=JWEoyrXZxxxzNMLhDiE5yyPaLMti4zmxGBlax2I7o0MC6BlHIonQ56WwKuvy66vBtg
         8cCn21zSdmWHhMq+ZXqpCh7ZjfjxePsHF5BdpIon4OTnecAmUFWoqy1GGsxSu6qkdWfM
         PmyPIn70vT/0p5qgDRk/0u2mme3shWABN3FlaxKtZB/nNRz5vAG57wuLItIRliEJwnCn
         MqAwTG3v4swIj0jHjDLAwobejfAVH0pnYhh4ZLHB2nDf2EOBEE43f16H4fmJyWGUJlL6
         kGOvuf5eTyZY7bE4kmVvqOfNedT2N6n20HYVfLCDoq8MZtbYUvJPb3M6brFihkFz8urX
         cTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5WzQlXC727GizG8RyV51VxxCJok7TVZDl6kolV1YY08=;
        b=qqFaHS60KBLl9m3DPs83PqZuEv0jZYV1pr9BNBjh4uhRUyXu2w8iYxUovkh7JloW/f
         SWiqwia96Rtt24EndA1Awf+G4xKyXDVRsxDyYnn2+9IQREjE8Gkdrbuh72xtnnEohK2T
         BXSIJlofyP3L9xSmrZghm8VllvEkwunOIceZpr6Z8tCd8eiH0YS0Wux3/2JynCAx04+1
         XeTHwMwTWU9rJ6By9Iad9+2C3Gj0aCAf/RxeHdLScVOj5/apQb7cNPWZS5t3Lw+u8lVq
         aQn1CKM531fvhJIXX63eT0eGIT+ZwCn7W6pcYKUzYLPpp77swe+rPzVQnMot6lFh7nQ0
         dBsg==
X-Gm-Message-State: AOAM532D6AWdjw5beEtjbTxsFQRGEY6PN9PdszC4tDBptRnAQ9KtVYOP
        zKFvcCbvavTsYg9Rbg3Q4nXX3jdV5myobA==
X-Google-Smtp-Source: ABdhPJyQo5ZLlGY7VhPt51F7spGXXx5RlOLCrsQguryaF7whJkVQaKOuWQzY0PXDbYePK1o9+CemLA==
X-Received: by 2002:a17:90a:f292:: with SMTP id fs18mr6520285pjb.142.1619193386917;
        Fri, 23 Apr 2021 08:56:26 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a16sm5372670pgl.12.2021.04.23.08.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:56:26 -0700 (PDT)
Date:   Fri, 23 Apr 2021 15:56:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
Message-ID: <YILuJohrTE+P06tt@google.com>
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
 <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
 <YIG6B+LBsRWcpftK@google.com>
 <a9f74546-6ab7-88fc-83d1-382b380f6264@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9f74546-6ab7-88fc-83d1-382b380f6264@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Krish Sadhukhan wrote:
> On 4/22/21 11:01 AM, Sean Christopherson wrote:
> > 		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
> > 
> > 		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4)) <- This reads vmcb12
> > 			return false;
> > 
> > 		svm->nested.msrpm[p] = svm->msrpm[p] | value; <- Merge vmcb12's bitmap to KVM's bitmap for L2

... 
 
> Getting back to your concern that this patch breaks
> nested_svm_vmrun_msrpm().  If L1 passes a valid address in which some bits
> in 11:0 are set, the hardware is anyway going to ignore those bits,
> irrespective of whether we clear them (before my patch) or pass them as is
> (my patch) and therefore what L1 thinks as a valid address will effectively
> be an invalid address to the hardware. The only difference my patch makes is
> it enables tests to verify hardware behavior. Am missing something ?

See the above snippet where KVM reads the effectively vmcb12->msrpm to merge L1's
desires with KVM's desires.  By removing the code that ensures
svm->nested.ctl.msrpm_base_pa is page aligned, the above offset calculation will
be wrong.
