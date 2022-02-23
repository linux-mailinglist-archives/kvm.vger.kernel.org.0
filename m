Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CCE4C128A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbiBWMQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240302AbiBWMQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:16:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CA209D06E
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645618552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHXmA1bybBOWdRTsj9cKfpCkNcAJNcNH0Oy4AsCUDmk=;
        b=cWheeMNctvgGDCqzOTl57UApZQVd44czzdeX6Sm1TLJWmBtD+CCJRaN1CLFaDq996WrCyL
        V/+LAd0H0f48ClF4K1IL3t8b5Qn0mYRh4TWzmBf8QHRj1xisGwXPShFu1wd2B7FzxBxsrd
        IgFt/Sb1paMnTAUOpcQ6LNAN39z+O/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-tsRIElOtMB-pdYZn45ADPA-1; Wed, 23 Feb 2022 07:15:49 -0500
X-MC-Unique: tsRIElOtMB-pdYZn45ADPA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52CF6801AB2;
        Wed, 23 Feb 2022 12:15:48 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E97277BB65;
        Wed, 23 Feb 2022 12:15:46 +0000 (UTC)
Message-ID: <e07aedc927a03bc921980430303864f34c34621e.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 23 Feb 2022 14:15:45 +0200
In-Reply-To: <YgaebIQH+IgsfQjf@google.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
         <20220211110117.2764381-4-pbonzini@redhat.com>
         <YgaYyJGN0v07vfzc@google.com>
         <3f8e8e3d-8bd7-dfd4-f4a0-63520d817c10@redhat.com>
         <YgaebIQH+IgsfQjf@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-11 at 17:35 +0000, Sean Christopherson wrote:
> On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> > On 2/11/22 18:11, Sean Christopherson wrote:
> > > > +		/* Process the interrupt with a vmexit.  */
> > > 
> > > Double spaces at the end.  But I would prefer we omit the comment entirely,
> > > there is no guarantee the vCPU is in the guest or even running.
> > 
> > Sure, or perhaps "process the interrupt in inject_pending_event".
> 
> s/in/via?
> 
> > Regarding the two spaces, it used to a pretty strict rule in the US with
> > typewriters.  It helps readability of monospaced fonts
> > (https://www.cultofpedagogy.com/two-spaces-after-period/), and code is
> > mostly monospaced...  But well, the title of the article says it all.
> 
> Preaching to the choir, I'm a firm believer that there should always be two spaces
> after a full stop, monospace or not.  Unless it's the end of a comment. :-D
> 
As someone who gotten into typewritter repair hobby lately, I sure understand what you mean.
But for some reason I still use one space after period even on a typewritter and
that doesn't bother me :-)

Best regards,
	Maxim Levitsky

