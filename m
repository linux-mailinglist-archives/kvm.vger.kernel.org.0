Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565551FC19B
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 00:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgFPWeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 18:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgFPWeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 18:34:25 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC68EC06174E
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 15:34:24 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k22so56016qtm.6
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 15:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ZmNYWaeeFv3Dc6ixQjxLv5HuZewlv2Zg/Sr+cvRX4hE=;
        b=dUQr4L49bnG3TuO9sz7aMFKYmqT3jGcXug9D9Wz7YNyvjOUwLYpuAGD9Mh3newVIQT
         vmrteic9VcFxcfGU8whoIXVqjQ6N6+uhZ93vQGklZiJa87U4gaU550pTpETcdOjkU48v
         f5DWiZNxQxTDblR1EtgQZz2INcQvf2zQAeQAiUnWwSghBr0giZsBXwYLZcxy+dNyYo7j
         Rvo6xjVR8Vk+ze54yxhJPip3EU6WuqrgnDILtr8qnNbIebPDD8XzwSBo3VxlQ59wCwq/
         uw6aV9Wa60yECrEYI1QfQgb6iqskMa+hNsjjY1IMSnZOTr3wP0y7q6qKUVvWfz6/PxSY
         yETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=ZmNYWaeeFv3Dc6ixQjxLv5HuZewlv2Zg/Sr+cvRX4hE=;
        b=uLsc/Ehdzrj/O1KLQhbutz3xFysWsguN2u7xmJe8Cpj/VzmcxwPfHq/tVRUtk+tsfu
         DDtUrc9R1e1PLx0U3dhwH0OABCRrsds7Y0ooxd9TECAEC1ZAGz9xBQ/5zGpscImwVsNt
         K+3Qpxz6t0vFpzbKCd2bNqAywArdnzs/MK90cWPrFCDtn8Ujsv1PdJdzU4ii+1VWkeaf
         s1t6mrF5IM6lhPVU6QoyZRMRGGk4qwVD8Fcfa/kO+GkktwYEfzx70iWi5R21IEaoz3ny
         3+Yec68buY+bDSHE3RsqAQnVcI+a4O0EMO5P7IZxr2uZNYbS6v/cxRdjiKjMU2MwX9XY
         rj/Q==
X-Gm-Message-State: AOAM530hQq0bI1wMUjlkgm/ZaKcDJJdoSdGv/861E0WdC2BxfHk82FRu
        7DktAFJhmEbQbwsjscsdD/44g3EtSCz5bQ==
X-Google-Smtp-Source: ABdhPJxHUzrw+EKluDSIJqczlcC1I9RUtmPTLvr08wFp1xZ9mBU2/yPKIK9sNsejd/aP9pjgWdnS5w==
X-Received: by 2002:aed:3f17:: with SMTP id p23mr23854259qtf.346.1592346863537;
        Tue, 16 Jun 2020 15:34:23 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id a191sm15221083qkc.66.2020.06.16.15.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 15:34:23 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] vfio/pci: Clear error and request eventfd ctx after releasing
Date:   Tue, 16 Jun 2020 18:34:22 -0400
Message-Id: <5F40A3A0-1C05-4411-B353-3D4F2E488EE7@lca.pw>
References: <159234276956.31057.6902954364435481688.stgit@gimli.home>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com, dwagner@suse.de
In-Reply-To: <159234276956.31057.6902954364435481688.stgit@gimli.home>
To:     Alex Williamson <alex.williamson@redhat.com>
X-Mailer: iPhone Mail (17F80)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 16, 2020, at 5:26 PM, Alex Williamson <alex.williamson@redhat.com> w=
rote:
>=20
> The next use of the device will generate an underflow from the
> stale reference.

Thanks Alex for taking care of this. I suppose my tests were too basic and n=
ever able to catch this underflow in the first place.=
