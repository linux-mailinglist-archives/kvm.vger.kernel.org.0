Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC69476F5C3
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 00:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjHCWgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 18:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbjHCWgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 18:36:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DFA4214;
        Thu,  3 Aug 2023 15:36:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b8ad356f03so10596325ad.1;
        Thu, 03 Aug 2023 15:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691102167; x=1691706967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dOiDF1oViVv0HssQmiTYLoC4V/AdLPs2KTPS/2fqvg0=;
        b=ghiHfuwrbozRBgICCOEVZK9yF7eoGF2tDymceKGZ76d/OkNnm6x6ePqd4zBQ2OxW71
         mPYxhqoeorXbQKyKNMGMiW4iJ3g2tRcyEK00Yy8JcDMgOpN140AI4U5xcqnYrnxfCpCZ
         62c2XqSKcRCJpdEwk5c7VYNqOUuK0Y1T+LXcuS8YHusHKV91vMP9Xde+7NUvC6TUr/Hb
         j5jvF1oooJ49/lUerFcDkzx+6emeSwGCBsYdaxJyEii9toCy0AOWtsLVS3l7i4CHem1X
         HzLmbnAOiP9fuBXsvwzrXzpwpoouJJqbhjbIUIfdhQdyBFUCLB/CHbBf5y4KUn2L5XTU
         incA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691102167; x=1691706967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOiDF1oViVv0HssQmiTYLoC4V/AdLPs2KTPS/2fqvg0=;
        b=cWWci9gB90GzrfMJ0rcSBaPeQOGZam6JicaAHHOFfO12VO1vbO/QKVN/mP5buGmimV
         uKhoAVUiTEu15UW73lyVPVkpffoZoQEnJMKmhp1mRa/aylhQMJEZxhEwMj9LjlMQan7Z
         3XpuhnRy2ncQcd8XOEeHvpOF1BE6gNt241TRUjp3DSx2kpzvn7P6Tlv+s9cvypg6yRHR
         pfribA8+L1sdFNldx8GPNyy41iz3k8JdIEWuLxwzWng65Z8I2LtxjAyXwDEtWfEo5YzH
         EB83lC2lZZeLFG7BtTEVlZ7fF+WkGA4aSa/hkfA2mesvKo1tZOojRdVGNCkeJXjaTgj/
         zPjQ==
X-Gm-Message-State: AOJu0YyBGMcZLCgxSGRLtj3QGNbtCOcrN3mkCtYQoBJdVxXJJo4aKxS9
        YEybVStbVJ1mGP9IaKkgVXg=
X-Google-Smtp-Source: AGHT+IHBGshNj2NZvckkkcuRexXLEcWTb5yDW1tKta6EGDefC5Cbc43YyEP0Ov6fyQq7rWLBdkAzUQ==
X-Received: by 2002:a17:902:aa05:b0:1b0:3637:384e with SMTP id be5-20020a170902aa0500b001b03637384emr75406plb.25.1691102166750;
        Thu, 03 Aug 2023 15:36:06 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:6f72:ed5c:19e0:a3d8])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902c1c500b001bbc9e36d55sm333447plc.268.2023.08.03.15.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 15:36:06 -0700 (PDT)
Date:   Thu, 3 Aug 2023 15:36:03 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <ZMwr06W5x/Lb19Wx@google.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
 <20230803133812.491956b9.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803133812.491956b9.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 01:38:12PM -0600, Alex Williamson wrote:
> On Fri, 14 Jul 2023 15:45:32 -0700
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
> > and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
> > dropping kv->lock. If we race group addition and deletion calls, kvg
> > instance may get freed by the time we get around to calling
> > kvm_vfio_file_set_kvm().
> > 
> > Previous iterations of the code did not reference kvg->file outside of
> > the critical section, but used a temporary variable. Still, they had
> > similar problem of the file reference being owned by kvg structure and
> > potential for kvm_vfio_group_del() dropping it before
> > kvm_vfio_group_add() had a chance to complete.
> > 
> > Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
> > of kv->lock. We already call it while holding the same lock when vfio
> > group is being deleted, so it should be safe here as well.
> > 
> > Fixes: 2fc1bec15883 ("kvm: set/clear kvm to/from vfio_group when group add/delete")
> > Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> 
> Applied series to vfio next branch for v6.6.  There's a minor rebase
> involved, so please double check the results:
> 
> https://github.com/awilliam/linux-vfio/commits/next

Looks good to me, thanks!

-- 
Dmitry
