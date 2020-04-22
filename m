Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A281B4DC8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 21:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgDVT4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 15:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgDVT4j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 15:56:39 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9163C03C1A9
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 12:56:37 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id j16so2974298oih.10
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 12:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=o9znY9dsi04w9M+M3bySEL0TwVDUInTJHIzNh81N4Fg=;
        b=Dg0mlK5rIYbJiP5d+1GNAONriuwLQzsCPBkzn8OUz0n4SHw9CgeQz5cLesg5qs7MwH
         l6nKcpAZUluqyA4aYxOwcjAXqq7JeWGJKl3ZlL1LIzn4gyVbOauilL7BU+F6szgOVMp4
         eU7gQbTak4tZnSKRpYleObad+oxBDlT8cEYBw0jv4OTdHyOijMVExXreJizIkzakprsn
         vavD3XyKVRQBGYqEiEGanXK8snDJ0pqZbWECPYGekkS5ErLAqZQJBF0+djLw4YRaW87X
         RASJB/TFjDqgpVYazjQ6CHoT4B6F7HQOJ+Wnwhd3XiThsq7RTW+5DeI6lsUcEjCp4An3
         +/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=o9znY9dsi04w9M+M3bySEL0TwVDUInTJHIzNh81N4Fg=;
        b=jxu5qg5F/FwGU0nMSg0LCQB3hrv469/lh3AWbjlIJmLNE22SBXj8nQ2pTTyHPHKW8R
         4bleOmYVzaekXrbYtyzcUdJjmVSb2G5MAU8hiQGd+htiQBu6g4AyYE9LNjcmYQHiA55w
         iipi5TGv3P7DoKQ0fYXoG7Ni5G3Z/UXnj2935Xtv5+pjHQhhbH+M2QoTPBwX/suSvWCt
         lXz7ynUVpeYwYTcI+dXkJF2iy82e+hKB5dOucpkR8N1dbstg2XROX9cfagRpO3DSoEoS
         Q9UVORuK9ouj023fP9BN3O5mguja3R5apj8eWKFYzLNEmiyHLHP1J7DhYi06FVuEa9AL
         bmnQ==
X-Gm-Message-State: AGi0PuafLFpFR6fpVS21lgI/DMTYenR7OgtHVcS8i1nLZlmu70UJz4gU
        +KttWBwGj0vIhyP3CdQuN/LRnrt+vEYY032ePTZg1qXnHi8=
X-Google-Smtp-Source: APiQypJ9xRSRoK2MhQd73k8mpRgo0u92aDjBIoDrEUQ8ESiZVQYYAmKdFPOfiRmFy8QjxN43Wm+PZzsQ0lHkdxvFax0=
X-Received: by 2002:aca:c385:: with SMTP id t127mr483394oif.49.1587585396740;
 Wed, 22 Apr 2020 12:56:36 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Anders_=C3=96stling?= <anders.ostling@gmail.com>
Date:   Wed, 22 Apr 2020 21:56:26 +0200
Message-ID: <CAP4+ddNe4wFunyH_qKQR5A_a+nwAmvE0COEVirnwUACk9jgpmQ@mail.gmail.com>
Subject: libvirt snapshot problem
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virsh snapshot-create-as --domain ubuntu-fs guest-state1 --diskspec
vda,snapshot=3Dexternal,file=3D/home/anders/overlay.qcow2 --disk-only
--atomic

returns this

error: internal error: unable to execute QEMU command 'transaction':
Could not create file: Permission denied

I found some bugs related to apparmor, and after doing this

aa-complain /etc/apparmor.d/libvirt/libvirt-`virsh domuuid ubuntu-fs`

I managed to create a snapshot, backup the base file and do a
blockcommit to merge the snapshot with the base. But on the subsequent
attempts, the Permission denied problem came back and persists. I am
running on Ubuntu 18.04, and apparmor is active.
--=20
---------------------------------------------------------------------------=
--------------------------------------------
This signature contains 100% recyclable electrons as prescribed by Mother N=
ature

Anders =C3=96stling
+46 768 716 165 (Mobil)
+46 431 45 56 01  (Hem)
