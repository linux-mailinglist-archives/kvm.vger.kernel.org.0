Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C73B722CD3
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjFEQiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjFEQiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:38:00 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482AD94
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:37:59 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a1e0cc1a2514c-789de11638fso1263684241.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685983078; x=1688575078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4GNtd8GQvgY7F2DHMM4zSSgC1V5KrK5LXShf2LAeh84=;
        b=d2cXwO6omaKLj3TF9XVq42fESQt6+RQeekobXZ3VLELNJjnmF8bzV6YiWcQXD3lgff
         T2ptMjKduZIcL5qCXwy5pJu/kHGFr51p9HipIihz0ZAukNUamMMZNQX5J+i/HIMZUGiJ
         CvnHGSY8mvwLCKP9N/q17/Gfs635PLDQP/xBZvMc4Lui+GVcCNojooh3m8J2ARU2bHfr
         QEmjAKUAxa9nosqwQdDgc8KKYTu06Gcr5IrgkkdMHAlAPbaNsYgL/4cEnuVbqtG4Vfzh
         vVUafCE2L2MJG7oTOhqvRw53McZSvssVCd5PHYG6acX1sVyO2seLRQvisOePwPyTjwkk
         ykMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685983078; x=1688575078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4GNtd8GQvgY7F2DHMM4zSSgC1V5KrK5LXShf2LAeh84=;
        b=QdZRjAUQiDFSrwIZei8B8BxD6F5xwJH9BLeAfZsjhauS9rIqx/e+FyLxuoufhh7QYv
         y8QURJGcdn7PJWJOX9W6Mc0AU6oFKf6AArLqdOzPRmcHrEemm8IvulkXe6smzf3LO0xV
         5MbjjudZUl5Cs7PO1kxT6j9Xxiy5+Kn1TYuiy3vxWB/QAkJ4yI92+SgUL2qDjx7ERRtj
         S4zV8fIpz+vQf1GDDOfUFeZOU+SWx1e1Oa5wQ7raafaSrTvhZ4UkE8nkv3HVhGfLSJy8
         CjZrOZErfn7ZweKNhBriUuTxJMXl+d7WqtzrMmuYzCh+sekN8LNDQhuW7YJblZXCdYVX
         uRog==
X-Gm-Message-State: AC+VfDxDV4X787w8zFW/I0L8skaC4g+KvItmWxGSwDCPjw4F16e0Fn/7
        BBOhHWTNX3z3dL1pwJmJU8UIY2QkVp1KExwgHOvRPA==
X-Google-Smtp-Source: ACHHUZ4gRpc6q7ReKbOOrt1DjQ8GOTzV3ROA2uR3fx5vrGDFukKvNPNd5Diam8tM0+WDBgl5vbrCCsJcsYbVUu0r+C8=
X-Received: by 2002:a1f:bd55:0:b0:45c:b73c:260c with SMTP id
 n82-20020a1fbd55000000b0045cb73c260cmr5834715vkf.12.1685983078309; Mon, 05
 Jun 2023 09:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <20230603165802.GL1234772@ls.amr.corp.intel.com>
In-Reply-To: <20230603165802.GL1234772@ls.amr.corp.intel.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Mon, 5 Jun 2023 09:37:19 -0700
Message-ID: <CAF7b7mr+suxFe63GXJWMK_XX8J1kp5Pi2yg_bNUi_0h0ub_4Jw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 3, 2023 at 9:58=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmail=
.com> wrote:
>
> UPM or gmem uses size instead of len. Personally I don't have any strong
> preference.  It's better to converge. (or use union to accept both?)

I like "len" because to me it implies a contiguous range, whereas
"size" does not: but it's a minor thing. Converging does seem good
though.
