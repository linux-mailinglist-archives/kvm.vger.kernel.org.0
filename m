Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CEE7D45DA
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 05:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjJXDRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 23:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjJXDRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 23:17:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DC0BC
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 20:17:34 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-53e751aeb3cso6095116a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 20:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698117453; x=1698722253; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j7+5QUAo2UOt8izQ1SjPKPLQvvl/vw27MMIOfZgGyFo=;
        b=eMy5Iu/1H/QtAG3WZozrBKog8nJKj9aIGDfkVZYtlj7ACYeGkNbOqX3IxVyj5OTxHm
         IhOKVvGF/vB3CkCHsV/Rz/Q19/1mHtxrephmY4aOhCd8Ag4ivV5D8cYp/ntx4Fkjokyi
         p7ZzQQPFRof0mRgIbh6KGj81s3B77dOsifrqj5lfOXb0eX9n1hnRBqYmRgxjYHNFSYbx
         qTkSb91s8Gd+QdB49l7eQPBALOAgzbR+jEnm3kJPr7eh0JL3gn93BkrY7Sg5qG5fhWrd
         1zxM/JVU7T+h5E8qMG587il/D+IwzYAJbhSwT2NMnNnGMpU70eO7KO0lGsAj+IjihKA/
         1kbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698117453; x=1698722253;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j7+5QUAo2UOt8izQ1SjPKPLQvvl/vw27MMIOfZgGyFo=;
        b=INFfyCJ0z+7PLun3Ga7lRe/5fgh5CfE2orhzYHbZiCqhD8ubKXVCOeu97iPRqhno1O
         ZQ2NVCbfibtg+yHTjdWx0gQLTbeGYycqIYJexLV8gTmAZ0rWlH9yVbiEqR+2I6OFag1f
         P1+pb4nz3qV3mfNQg9m/iUTu93mqRRNHffkT1QXqlFaaDTl5IZNYXFMlTQphLhaDIt7E
         WtgEuf/VQXvh/vAN4R0nPHIAB89rDjLEoW/lIVwrA4Yv95TRLN/Xvz2lsAhnQsh4TrIJ
         g2XOSBKnN0O8UGt+1Vi1E4Dnw8xfVuba5fcedfr+/Z0w+8DbkxxM6IjSBOvWzSfgboUw
         //Dw==
X-Gm-Message-State: AOJu0YwBE1bCERp8biCYEmoI7u0qa13v2ET9Q9TUPZAWol3jUHyVMygS
        I/GBFEZukoMVNmlZEChitA5VSClOYZDdcqyE6O1uPprYyEw=
X-Google-Smtp-Source: AGHT+IG8tJnulcq9aalq3wkuxo47FPUL6DR+V3ke9GypTtRossSLtW9VLw3Lkp0jZxXFk6nhJwYgVt3HLPGNZkBVuOQ=
X-Received: by 2002:a50:d094:0:b0:53e:df4:fe72 with SMTP id
 v20-20020a50d094000000b0053e0df4fe72mr7228173edd.32.1698117452658; Mon, 23
 Oct 2023 20:17:32 -0700 (PDT)
MIME-Version: 1.0
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Tue, 24 Oct 2023 11:17:20 +0800
Message-ID: <CAKhg4tKSWLood9aFo7r1j-a3sXvf+WraFV_xUcKOMLq9sxrPXA@mail.gmail.com>
Subject: [RFC] vhost: vmap virtio descriptor table kernel/kvm
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current vhost code uses 'copy_from_user' to copy descriptors from
userspace to vhost. We attempted to 'vmap' the descriptor table to
reduce the overhead associated with 'copy_from_user' during descriptor
access, because it can be accessed quite frequently. This change
resulted in a moderate performance improvement (approximately 3%) in
our pktgen test, as shown below. Additionally, the latency in the
'vhost_get_vq_desc' function shows a noticeable decrease.

current code:
                IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:        vnet0      0.31 1330807.03      0.02  77976.98
0.00      0.00      0.00      6.39
# /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
avg = 145 nsecs, total: 1455980341 nsecs, count: 9985224

vmap:
                IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:        vnet0      0.07 1371870.49      0.00  80383.04
0.00      0.00      0.00      6.58
# /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
avg = 122 nsecs, total: 1286983929 nsecs, count: 10478134

We are uncertain if there are any aspects we may have overlooked and
would appreciate any advice before we submit an actual patch.


Thanks,
Liang
