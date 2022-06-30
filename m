Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8AF562539
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 23:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbiF3V1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 17:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiF3V1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 17:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0F6B35AA9
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 14:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656624455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wd1ki83p3SXylkpu3EgQoI69vBxY8no6C/MZWnJcErg=;
        b=VlxOTAqLEPo1xuRDRR/dg76LNpWP1wXxflag94wdkZnxhepasM08EGh9RkPXmCUmmH8DwA
        D73bYKIuC2T13oll1YtrpbzyQBBv/0j99r/UoCHu+JT4uHnTVZi0fyKnM7zcgSWRleGrJm
        4+3DJX6FOXvIjJ0NLGFZON7ol1og6i4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-TdR4cO4wOt63WdycKHhNiw-1; Thu, 30 Jun 2022 17:27:34 -0400
X-MC-Unique: TdR4cO4wOt63WdycKHhNiw-1
Received: by mail-il1-f199.google.com with SMTP id i2-20020a056e021b0200b002dadf6a0a0eso139034ilv.12
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 14:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wd1ki83p3SXylkpu3EgQoI69vBxY8no6C/MZWnJcErg=;
        b=wSI1wS3E2+AXA3Jn9+rP4nXT+TMPkro0TKIGI+T2PIxXRJ9QYUzmvPEezY0L3XLASz
         rgFCkNWjV11ZDlVE8Rn6Isbl447WEtI0AKXULWcsNjYliJIYFeeePbo48tpqVGxNNnik
         li9A26aU94rwHtFV+uUVIYuNI+s2L2d4S1DiD9PaLnco82P+DFOcQwsAfXMIfBz+E+23
         +xTx+kptx13FEw5Nm7qCXRIkdCandP/HYstcQEpQpJUnwQjSuM6EGVfb7gsnLgO8rit/
         gLatMNoNxUtISsqik61TdiqU5Nw4o2Uu5jqviJrA9PoOKMQvPfhemVbjTaMAXnx3mAb0
         tdhg==
X-Gm-Message-State: AJIora/7YTa8Ak/HJRoxsvxCxXf34+XVehprtEMzFph/ttoioqvYqwiR
        gtE/oPvFglsMJbguidHQL7UGTKwLPl8osEUBwByz1pdXL0bRdBV74k9S+/znfNlS8xOHAnyF6+M
        qmNzu0QdvdU5Q
X-Received: by 2002:a6b:fb05:0:b0:657:655e:a287 with SMTP id h5-20020a6bfb05000000b00657655ea287mr5835540iog.211.1656624453803;
        Thu, 30 Jun 2022 14:27:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t78+bU25q9esv1lcWaU4zBR2o8PbPeqMIreeppu9DzAo0eFqpPx7c+rMK82ivDZlWfZZexEQ==
X-Received: by 2002:a6b:fb05:0:b0:657:655e:a287 with SMTP id h5-20020a6bfb05000000b00657655ea287mr5835526iog.211.1656624453577;
        Thu, 30 Jun 2022 14:27:33 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id e98-20020a02866b000000b00331598832besm9005563jai.25.2022.06.30.14.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 14:27:32 -0700 (PDT)
Date:   Thu, 30 Jun 2022 17:27:30 -0400
From:   Peter Xu <peterx@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <Yr4VQqTIu1bMEAji@xz-m1.local>
References: <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
 <YrtXGf20oa5eYgIU@xz-m1.local>
 <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
 <YruBzuJf9s/Nmr6W@xz-m1.local>
 <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
 <Yrx0ETyb2kk4fO4M@xz-m1.local>
 <17f9eae0-01bb-4793-201e-16ee267c07f2@nvidia.com>
 <Yr2p7sR3IjiGTGd3@xz-m1.local>
 <0183984a-c95f-c92e-629e-775071b5cd23@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0183984a-c95f-c92e-629e-775071b5cd23@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 12:01:53PM -0700, John Hubbard wrote:
> On 6/30/22 06:49, Peter Xu wrote:
> > Looks good to me, I'd tune a bit to make it less ambiguous on a few places:
> > 
> > 		/*
> > 		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
> > 		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
> > 		 * That's because some callers may not be prepared to
> > 		 * handle early exits caused by non-fatal signals.
> > 		 */
> > 
> > Would that be okay to you?
> > 
> 
> Yes, looks good. With that change, please feel free to add:
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>

Will do, thanks!

-- 
Peter Xu

