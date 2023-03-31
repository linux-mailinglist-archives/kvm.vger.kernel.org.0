Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679026D23CB
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjCaPQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 11:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbjCaPQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 11:16:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB842D73
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680275716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jReYaRvaeLpOpGhoWxZkfcictVQRNAgQCVGzZlNYJVk=;
        b=hYTpVc65/waRS6XkwouiumvrODko+aK08YeBNXfrbDRt+9mWmeOabgczdmNa8MefBaZZr9
        1hT5C7L8lf2gFH1Zb5XUCUL1XCwwrOxjUyHBgwG/OGiMFHJwFNvJOvGyNxrXeKV3swatpA
        A7hk4IYuDlLRCJF3bSo5f/Ac3q7Xj0g=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-veFRAC0JNnmGMTA0t7aORQ-1; Fri, 31 Mar 2023 11:15:14 -0400
X-MC-Unique: veFRAC0JNnmGMTA0t7aORQ-1
Received: by mail-vs1-f70.google.com with SMTP id e12-20020a67e18c000000b00425e6c65700so7153344vsl.18
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 08:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680275713; x=1682867713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jReYaRvaeLpOpGhoWxZkfcictVQRNAgQCVGzZlNYJVk=;
        b=QKrUHXh4qQCrjvFHrWarjtkOgOW+rGhdwNUkRW37IFjpFu/LNnOFfqNkHXMFeZ6mk9
         z+0/DiPcL23aNA3LufwgYrPKa8vQgIactCf9XlzYBEZb+v6RTQL5pA4yRZbZgsXsPzqj
         lZQv/0lL9sCMsoNGuWVi1UIOpq4JGxKsEFwQBcF3xn7jgd7+wQk+eg3uMITHUH5jg1rw
         33jCCBsKr6md+cv2szvc799czzEvODbSfFcUlD6AppsnsWLULVjKBoPitpfLqP6Zy7wC
         2De0srq8qAj4SJEBtEoeK9k1Dyn8CEmQSt78yYkKBEvO9Sq3FF1oPPnHGiN/sp6zqcQF
         Ox5g==
X-Gm-Message-State: AAQBX9fqRPEV8kzAs57kALDNCKX9SAPZLpYvnaRKDyj6EG4NM6wMmBqQ
        qs58gYDjh1qkpo1pZWwc6yWfM5ad7HdNkwfNv9Rc9bP58SB9oScewmsRDtN13sy3Tsnt2y3mHUT
        lDaVsq97w+2RrQi/Mfosa1RGbzk3M
X-Received: by 2002:a67:cc1b:0:b0:412:4e02:ba9f with SMTP id q27-20020a67cc1b000000b004124e02ba9fmr14336238vsl.1.1680275713573;
        Fri, 31 Mar 2023 08:15:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350bnlCOJmQOLM6/M2bAAW0kF15+DEKJBLkDXCC/WvhP7MCxMgiyX7jFmq4Pg6eh841W2LJ3aSzVsc5nh2XEXVVg=
X-Received: by 2002:a67:cc1b:0:b0:412:4e02:ba9f with SMTP id
 q27-20020a67cc1b000000b004124e02ba9fmr14336228vsl.1.1680275713266; Fri, 31
 Mar 2023 08:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230329135129.77385-1-frankja@linux.ibm.com>
In-Reply-To: <20230329135129.77385-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 31 Mar 2023 17:15:02 +0200
Message-ID: <CABgObfYTkZsHS9xfqO32LMcH9=mZepb6QY2=B_Fn+UwEe-6EWQ@mail.gmail.com>
Subject: Re: [GIT PULL 0/1] kvm/s390: Fixes for 6.3
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pulled, thanks.

Paolo

On Wed, Mar 29, 2023 at 3:52=E2=80=AFPM Janosch Frank <frankja@linux.ibm.co=
m> wrote:
>
> Dear Paolo,
>
> currently we only have one fix patch to offer which repairs the
> external loop detection code for PV guests.
>
> Please pull,
> Janosch
>
> The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292=
aa:
>
>   Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-master-6.3-1
>
> for you to fetch changes up to 21f27df854008b86349a203bf97fef79bb11f53e:
>
>   KVM: s390: pv: fix external interruption loop not always detected (2023=
-03-28 07:16:37 +0000)
>
> Nico Boehr (1):
>       KVM: s390: pv: fix external interruption loop not always detected
>
>  arch/s390/kvm/intercept.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
> --
> 2.39.2
>

