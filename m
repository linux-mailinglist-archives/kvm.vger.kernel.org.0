Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509FA5F6A7C
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 17:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiJFPYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 11:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiJFPYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 11:24:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA224B56EF
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 08:24:02 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso4625558pjf.5
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JBOIKDUVixWKZNhUdADJJBE2P5/4OiKvNbwBGIFtxk4=;
        b=o8fPLBde6yfpzUbok/9JvpWiEb2rfI+Wo7yWbvMrDKNePP0NZLp4uWEqOIZ6gXH4Db
         pLmZg3nSQ/WLphaATMVn97HqgT/qDKuEgKyJM8oPVRq1GIxpU9X7bCWoY1CC/PJRXu3O
         c2MA5QL0Sp1Zcr5SOd3jY2twLvh0UC5qvPvwrqGpaIecA3cCIliP1X6zG/W9GeIOSQij
         M5T+IdA9rPXGZ9juH7KmtPqDivh3lGWCDF1cywxnewrYBSbey3niaYG76b7YLzRWFKaI
         neBLw9X50E7b9ZDbhZMvPd1oyCPViMDrpvOj44JJYwxLOkdxVt233DfbdsT7nPASERb5
         GUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JBOIKDUVixWKZNhUdADJJBE2P5/4OiKvNbwBGIFtxk4=;
        b=CesJ8sPQQ9TC39iY5yxz7oorkxZIdiCd12TaCN4rbzEJ9Bo126KYHweJ7W4CRr3qRO
         ZUHvRxsVYhcj9fCmjfovOo90w2Z0OpD5LiHZqvLx9jUe6vz1OraiLPrenIzJKz1dNmHe
         tZ6xLgiFYPEEfx8TOzidPrxq2m4bl+VjiZ5H02ujWh8aU+fSJgycbaAsOqA0l1QEijzZ
         Sr07LLIqrNlC6ZoctknqIt1u+xuPUdTcDIGklz1Nh6jPhezzwcto5/n2AXg4o2viItMh
         CioozLEATf8u4D4EJTKb/6xSRcvflZ7/+lC/T7G0HrF4hz3S6BAHoGwVeeR5BO9nHttW
         ABcw==
X-Gm-Message-State: ACrzQf1RtEYZCK1GPPWOt+Xo5Os7soUD3zm5uD3U/tZl2+uywdvbkYv/
        90YqDWC5E67VbFrtM30qk8MWTQ==
X-Google-Smtp-Source: AMsMyM6MFHtoN5xTEoDaY7W8iu+aJLGQ5Wu5lUF7zz2/8KfNaAQtMBim5YUQyrdBuMHL5edejnQdOA==
X-Received: by 2002:a17:903:11c7:b0:178:af17:e93e with SMTP id q7-20020a17090311c700b00178af17e93emr38212plh.78.1665069841227;
        Thu, 06 Oct 2022 08:24:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 127-20020a620685000000b00540f96b7936sm13049971pfg.30.2022.10.06.08.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 08:23:57 -0700 (PDT)
Date:   Thu, 6 Oct 2022 15:23:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Li <ercli@ucdavis.edu>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON
 CR0/CR4 check fails
Message-ID: <Yz7zB7Lxt2DHa4nT@google.com>
References: <20221006001956.329314-1-seanjc@google.com>
 <783d89e3c98ee933ec789f1bffc6873ac3ac2e7a.camel@ucdavis.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <783d89e3c98ee933ec789f1bffc6873ac3ac2e7a.camel@ucdavis.edu>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022, Eric Li wrote:
> 在 2022-10-06星期四的 00:19 +0000，Sean Christopherson写道：
> > Eric, any testing you can provide would be very welcome.  It took me
> > an
> > embarassingly long time to wrap my head around the SDM's pseucode.  I
> > _think_ I got it right this time...
> 
> I tested by applying the patch to Linux 5.19.14 tarball I downloaded
> from kernel.org. The fix looks good on my end.

Thanks!  Was just doing the same.  :-)
