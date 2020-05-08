Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3551CB44E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 18:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEHQFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 12:05:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726825AbgEHQFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 12:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588953936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzNGIg9wCojzQE1LmaJBjj2Riqjs4hcmRh8uNcepGBA=;
        b=Y2Xga9iAmDo6y0Bo2A6YoNmxLVPazm4QajSf8Iz+ZcU1c1YKwxk90bUqPYPPb86wcFmaA+
        QPEX1hsIhvElZcapmWSq4icCJfsaWwrnzKnuHgjkRapPMl8oCTseK2CZGNIvXSBKlm3n/4
        k8ZaBjO2b3boT1ZPPPiup8lPEXo2oww=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-KPE6IlAQNwSr5OvtkBZ_MQ-1; Fri, 08 May 2020 12:05:34 -0400
X-MC-Unique: KPE6IlAQNwSr5OvtkBZ_MQ-1
Received: by mail-qt1-f200.google.com with SMTP id z5so862922qtz.16
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 09:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SzNGIg9wCojzQE1LmaJBjj2Riqjs4hcmRh8uNcepGBA=;
        b=pfcmDiJLD++Ay2GrN1v5t4F014nfTJsPXjnn7sj5SbArQFNTeLmsF4w1WzgR8TZFNs
         aR6djPBk3W+8DTbbetVn3enZB/4lmbEERXkPjqYrSfquL06kBsENEszJ83H8nlLIg9ej
         AFdcKHrnMjUc8F63a7NFhrAFU/+mVS0tDv/PgOlh0Rl5mDzaqjsX9Mb/9GdTUFZsSNna
         YQjWt6M6Evf572x32c2c/kIJXfkFFFD3hOUugMK7N3zA+A3jXvS8n88GcAgQ+4jOHAci
         Ij21EjG3pcfq8oYQCOxydMQnovTOKnzWDU51UUblAlVG5AdV1IrPKqyLjsQhUFSQmCB5
         tSGQ==
X-Gm-Message-State: AGi0Pubivpf9h+rJ/wMsi1/dSCk/oeKIAQhCOVMOa1pAIaQFbzNuJ4/o
        HLW5DuuhrT2ND1PwEJO3YClJgcZD5rdyJF+qpXfHsWC24LAQiK/I62YPVbtgD1g4myOuR/ukxwP
        jRl9/GCeDlAyw
X-Received: by 2002:a05:6214:42b:: with SMTP id a11mr3487479qvy.186.1588953934343;
        Fri, 08 May 2020 09:05:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypJEZbUB9JpX5nQ5mBjKk/50jvAujXFWp5fDu/JL2c2EKEzr4jVhJs06Er18X2ZJXYM9xvwVNA==
X-Received: by 2002:a05:6214:42b:: with SMTP id a11mr3487445qvy.186.1588953934079;
        Fri, 08 May 2020 09:05:34 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t7sm1700790qtr.93.2020.05.08.09.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 09:05:33 -0700 (PDT)
Date:   Fri, 8 May 2020 12:05:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200508160532.GB228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871568480.15589.17339878308143043906.stgit@gimli.home>
 <20200507212443.GO228260@xz-x1>
 <20200507235421.GK26002@ziepe.ca>
 <20200508021939.GT228260@xz-x1>
 <20200508121013.GO26002@ziepe.ca>
 <20200508143042.GY228260@xz-x1>
 <20200508150540.GP26002@ziepe.ca>
 <20200508094213.0183c645@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200508094213.0183c645@w520.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 09:42:13AM -0600, Alex Williamson wrote:
> Thanks for the discussion.  I gather then that this patch is correct as
> written, which probably also mean the patch Peter linked for KVM should
> not be applied since the logic is the same there.  Correct?  Thanks,

Right.  I've already replied yesterday in that thread so Paolo unqueue that
patch too.  Thanks,

-- 
Peter Xu

