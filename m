Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6588E1EB290
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 02:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgFBALN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 20:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFBALN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 20:11:13 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDBDC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 17:11:13 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id s18so8976578ioe.2
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 17:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=v9uzAaC7HJVWcGRrRi0P7AwP4KcGcm5IFgUEhCiaK14=;
        b=u4JfX/EW12ozz3qwlI6g/3Ql7d0Iu7RYNXDsO3EfOC/+b1sdxJq10jNkKF/EXhfz7x
         lNxvt8olkFwkP03Oh7Q59lCbEEENFgz2Jy5HrKhpiuUfn+9YzR/84x5ZTX4LTTSdXjM3
         UEqdRWKRYVFbGVd3yUJeHCbOjc63t8T9wkqlXjn5PT7RDf8VCrI1sRQEJaPzsMjbkGMm
         P0AmvcgUoeIGyaClc3eBYOF0bXdLBBaYdcAG6Xgc1Tm0FcZl4i3NvLRAzI0wdsvUtn9b
         rCoI3GjCQiwpBl0t0pK8SdOwGDMJS+84/rIIXwYuzIhD9PqUz0fYFhBJamPCEY3dEp8z
         kLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=v9uzAaC7HJVWcGRrRi0P7AwP4KcGcm5IFgUEhCiaK14=;
        b=ep9L1XUUKYUdh13ncxrfQJfsrsFIr9tdbqRdo/OOFTT5Vd/p7DCzcnqLtUGjsa8zxK
         3pUAoJIygaU036zyrSi7+W6rtLsczc4+9L6CSBGJrEo4ZtUg3p8yz3o/okVx2SjJkSjv
         /IeKgkKkB7zdcOFj0LjahJGE0+vkGLgzenIgSoVTr/qqcY0z6AGIvY0sxEJeK77HE4Ji
         cFIkfOgnU6VPYjjvnIH3E1alX3oAkFH4dGPuQvDgkRxgbz2hO/UmG874QNpeNk6jFzhu
         XojBFwQiO2OwBu5BAFJSGCBsYqzF1+ZZN263MuCCIZSVpHz9XWMEIYZ6PNnTolPAJ6Y9
         OZ1Q==
X-Gm-Message-State: AOAM533TbRFyPJZcZyJaihhiFG6CZIkZniyNpud+pW7x+zQPmr0+xapk
        pI4pV0/UC1/X1v3LgptATM3Rnakty8narG9O5vu5efi6EIc=
X-Google-Smtp-Source: ABdhPJwKTUc2kDCCH+JQQadb9P65RUZtXQ75iMcc6Lj2BYxwIi3DxCi57Tn/DkJeZnP0FiWp7L8QPZ2T5VZDn8NmPvY=
X-Received: by 2002:a5e:a705:: with SMTP id b5mr21174653iod.12.1591056671376;
 Mon, 01 Jun 2020 17:11:11 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 1 Jun 2020 17:11:00 -0700
Message-ID: <CALMp9eS2UtMazBew2yndKVXC0QnnBW2bvbU_d+27Hp7Fw2NXFg@mail.gmail.com>
Subject: PAE mode save/restore broken
To:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I can only assume that no one cares that KVM_GET_SREGS/KVM_SET_SREGS
is broken for PAE mode guests (i.e. KVM_GET_SREGS doesn't capture the
PDPTRs and KVM_SET_SREGS re-reads them from memory).

Presumably, since AMD's nested paging is broken for PAE mode guests,
the kvm community has made the decision not to get things right for
Intel either. Can anyone confirm? This was all before my time.
