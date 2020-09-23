Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81A4275922
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgIWNvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:51:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726572AbgIWNvF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 09:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600869064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pGCTwF8go0vEZUmXsGyvz8lI/OeV1VqKy4Zgp1Xxw0Y=;
        b=Z0K+GpyGw7dpnBZGf4mVz9jtP3FpIsat8wgl/ByrMMCr5Nh+R+RZp2UK+G5JblHzKfcAOq
        z2n9gizI4JFt1KCNRsRT8O1FdhFDrLx2AdxGZl5+KIYbGPncIzAMwfmhJX3cZuW3/NlVM/
        a+Q0GPdEybZNupPBVBo/sAzOSyhCgus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-akYQouafNVO338eMB2N0GA-1; Wed, 23 Sep 2020 09:51:01 -0400
X-MC-Unique: akYQouafNVO338eMB2N0GA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3794F8ECE51;
        Wed, 23 Sep 2020 13:51:00 +0000 (UTC)
Received: from starship (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F4085D993;
        Wed, 23 Sep 2020 13:50:59 +0000 (UTC)
Message-ID: <126ab56ea11b435aedc98ca82a112cf83a60eaf8.camel@redhat.com>
Subject: Re: [bug report] SVM: nSVM: setup nested msr permission bitmap on
 nested state load
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
Date:   Wed, 23 Sep 2020 16:50:58 +0300
In-Reply-To: <20200923134455.GA1485839@mwanda>
References: <20200923134455.GA1485839@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-09-23 at 16:44 +0300, Dan Carpenter wrote:
> Hello Maxim Levitsky,
> 
> The patch 772b81bb2f9b: "SVM: nSVM: setup nested msr permission
> bitmap on nested state load" from Aug 27, 2020, leads to the
> following static checker warning:
> 
> 	arch/x86/kvm/svm/nested.c:1161 svm_set_nested_state()
> 	warn: 'ctl' not released on lines: 1152.
> 
> arch/x86/kvm/svm/nested.c
>   1135          if (!(save->cr0 & X86_CR0_PG))
>   1136                  goto out_free;
>   1137  
>   1138          /*
>   1139           * All checks done, we can enter guest mode.  L1 control fields
>   1140           * come from the nested save state.  Guest state is already
>   1141           * in the registers, the save area of the nested state instead
>   1142           * contains saved L1 state.
>   1143           */
>   1144          copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
>   1145          hsave->save = *save;
>   1146  
>   1147          svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
>   1148          load_nested_vmcb_control(svm, ctl);
>   1149          nested_prepare_vmcb_control(svm);
>   1150  
>   1151          if (!nested_svm_vmrun_msrpm(svm))
>   1152                  return -EINVAL;
> 
> goto out_free?
> 
>   1153  
>   1154          svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
>   1155  
>   1156          ret = 0;
>   1157  out_free:
>   1158          kfree(save);
>   1159          kfree(ctl);
>   1160  
>   1161          return ret;
>   1162  }
> 
> regards,
> dan carpenter
> 
Which kernel tree is this? 

This again seems to be the result of other commit
that made save, ctl to be dynamically allocated. I based my patch on the version
that allocates both on the stack so no freeing is needed.

As far as I know from a check I did about week ago, none of branches on 
git://git.kernel.org/pub/scm/virt/kvm/kvm.git had that patch (that made save/ctr
be allocated dynamically).

Best regards,
	Maxim Levitsky



