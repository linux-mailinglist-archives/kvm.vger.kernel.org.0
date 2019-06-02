Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550AE324CE
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 22:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFBUtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 16:49:47 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:36460 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFBUtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 16:49:47 -0400
Date:   Sun, 02 Jun 2019 20:49:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1559508580;
        bh=hQrvJPo5qatBRI4sRrtluSfyq+0472IYh8lDIt4jAno=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=nmJ0v/owVtT1vk2tEMcnqxT340ULcCpJiZxJgN/7uTig1rh7j5UVWQAJkcEgB6Bwu
         owTw394xdFAuVHfu9dGEAd0rkjvUZyvGJNaIqGYdkVqJjMp4CmWfvgLyVhjugbhybi
         luu96hK50pVbZDbzI5L6pMLsMM0yLzANu7Uiy2tU=
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   nucleare2 <nucleare2@protonmail.com>
Reply-To: nucleare2 <nucleare2@protonmail.com>
Subject: Re: GPU passthrough hot-swapping driver development?
Message-ID: <NSZOGDLSVPu40Ch8eOrf0JQaHx53jz3bJr3ObXdpT6riMCAcivu6wVdRC61HE1fkMnOMTUIysb00W4BqDhpIg3EALXCHPl_ZCECBRtGNstI=@protonmail.com>
In-Reply-To: <7m5yGq2nqhDfQvcZCjBDqj8OEu2o1QDrqiy-MdHrni7Qw8rwHrdkBMtEisMnEG1dgB6lSJI-MleT0EAlkZE28gRfQqjXJsDRlCgsNJw7oPQ=@protonmail.com>
References: <7m5yGq2nqhDfQvcZCjBDqj8OEu2o1QDrqiy-MdHrni7Qw8rwHrdkBMtEisMnEG1dgB6lSJI-MleT0EAlkZE28gRfQqjXJsDRlCgsNJw7oPQ=@protonmail.com>
Feedback-ID: 6cK2ugpeksPec3rG16mXEaHR9GhrR_B-m0z3L-xAiYND-P5vD9hHafIOg6bgnbygXCX6rz6IkScptBLgDrGM0A==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given that there's been no response yet, I wanted to hopefully clarify what=
 I'm talking about by providing a couple diagrams and maybe some clarifying=
 terminology. I'm not sure if these diagrams will look right for everyone, =
so I'll also include a link to an image for each one above it.

First, please correct me if I'm wrong, but I believe the following diagram =
represents a very basic visualization of KVM + QEMU:

Image: https://i.ibb.co/smh9Rv4/KVM-and-QEMU.png

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90
=E2=94=82    Native     =E2=94=82   =E2=94=82    Guest     =E2=94=82   =
=E2=94=82    Guest     =E2=94=82
=E2=94=82   Software    =E2=94=82   =E2=94=82      VM      =E2=94=82   =
=E2=94=82      VM      =E2=94=82
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=98   =E2=94=82              =E2=94=82   =E2=94=82              =
=E2=94=82
        =E2=94=82           =E2=94=82              =E2=94=82   =E2=94=82   =
           =E2=94=82
        =E2=94=82           =E2=94=82              =E2=94=82   =E2=94=82   =
           =E2=94=82
        =E2=94=82           =E2=94=82              =E2=94=82   =E2=94=82   =
           =E2=94=82
        =E2=94=82           =E2=94=82      =E2=95=91       =E2=94=82   =
=E2=94=82              =E2=94=82
        =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4
        =E2=94=82           =E2=94=82      =E2=95=91       QEMU            =
   =E2=94=82
        =E2=94=82           =E2=94=82      =E2=95=91                       =
   =E2=94=82
        =E2=94=82           =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
        =E2=94=82                  =E2=95=91  GPU           =E2=94=82
        =E2=94=82                  =E2=95=91Passthru        =E2=94=82
        =E2=94=82                  =E2=95=9A=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=97       =E2=94=82
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82                                =E2=94=8C=E2=94=80=E2=94=80=
=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90  =
=E2=94=82
=E2=94=82Linux (kernel)                  =E2=94=82  =E2=95=91    KVM       =
=E2=94=82  =E2=94=82
=E2=94=82                                =E2=94=94=E2=94=80=E2=94=80=
=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98  =
=E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82                                   =E2=95=91                 =
=E2=94=82
=E2=94=82                 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90=E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=
=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90=E2=94=82
=E2=94=82HARDWARE         =E2=94=82  GPU1   =E2=94=82=E2=94=82         =
=E2=94=82   =E2=94=82         =E2=94=82=E2=94=82
=E2=94=82                 =E2=94=82  (host  =E2=94=82=E2=94=82  GPU2   =
=E2=94=82...=E2=94=82  GPUn   =E2=94=82=E2=94=82
=E2=94=82                 =E2=94=82reserved)=E2=94=82=E2=94=82         =
=E2=94=82   =E2=94=82         =E2=94=82=E2=94=82
=E2=94=82                 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=94=94=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98


What I'm considering or asking about is the development of something I'll c=
all a "soft video switch" within Linux that perhaps lives beside KVM or som=
ehow works with KVM to facilitate quick switching between direct passthroug=
h of graphics for the HOST or GUEST(s):

Image: https://i.ibb.co/gSLybZy/KVM-and-QEMU-with-soft-video-switch.png
                                                         =E2=94=82=E2=94=
=82
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90      =E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=97
=E2=94=82    Native     =E2=94=82   =E2=94=82    Guest     =E2=94=82   =
=E2=94=82    Guest     =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91  EXPANDED V=
IEW of "soft video switch"   =E2=95=91
=E2=94=82   Software    =E2=94=82   =E2=94=82      VM      =E2=94=82   =
=E2=94=82      VM      =E2=94=82      =E2=95=91                            =
             =E2=95=91
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80direct guest video=
=E2=94=80=E2=94=80=E2=94=90             =E2=95=91
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82      =E2=95=91         driver access     =
=E2=94=82             =E2=95=91
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90   =
       =E2=94=82             =E2=95=91
=E2=94=82               =E2=94=82   =E2=94=82              =E2=94=82   =
=E2=94=82              =E2=94=82      =E2=95=91       direct host video   =
=E2=94=82             =E2=95=91
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=98   =E2=94=82              =E2=94=82   =E2=94=82              =
=E2=94=82  =E2=94=82=E2=94=82  =E2=95=91         driver access     =
=E2=94=82             =E2=95=91
        =E2=94=82           =E2=94=82              =E2=94=82   =E2=94=82   =
           =E2=94=82      =E2=95=91         =E2=94=8C=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90      =
=E2=95=91
        =E2=94=82           =E2=94=82              =E2=94=82   =E2=94=82   =
           =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91         =E2=94=82   sof=
t video switch    =E2=94=82      =E2=95=91
        =E2=94=82           =E2=94=82      =E2=95=91       =E2=94=82   =
=E2=94=82              =E2=94=82      =E2=95=91         =E2=94=82          =
              =E2=94=82      =E2=95=91
        =E2=94=82           =E2=94=82      =E2=95=91       =E2=94=82   =
=E2=94=82              =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91         =
=E2=94=82           =CE=9B            =E2=94=82      =E2=95=91
        =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4      =E2=95=91   =
      =E2=94=82          =E2=95=B1 =E2=95=B2           =E2=94=82      =
=E2=95=91
        =E2=94=82           =E2=94=82      =E2=95=91       QEMU            =
   =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91         =E2=94=82         =
=E2=95=B1   =E2=95=B2          =E2=94=82      =E2=95=91
        =E2=94=82           =E2=94=82      =E2=95=91                       =
   =E2=94=82      =E2=95=91         =E2=94=82        =E2=95=B1     =
=E2=95=B2         =E2=94=82      =E2=95=91
        =E2=94=82           =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98  =E2=94=82=
=E2=94=82  =E2=95=91         =E2=94=82    =E2=94=8C=E2=94=80=E2=94=80=
=E2=96=95       =E2=96=8F=E2=94=80=E2=94=80=E2=94=80=E2=94=90    =E2=94=
=82      =E2=95=91
        =E2=94=82                  =E2=95=91   GPU          =E2=94=82      =
          =E2=95=91         =E2=94=82    =E2=94=82   =E2=95=B2     =
=E2=95=B1    =E2=94=82    =E2=94=82      =E2=95=91
        =E2=94=82                  =E2=95=91 Passthru       =E2=94=82      =
      =E2=94=82=E2=94=82  =E2=95=91         =E2=94=82    =E2=94=82    =
=E2=95=B2   =E2=95=B1     =E2=94=82    =E2=94=82      =E2=95=91
        =E2=94=82                  =E2=95=9A=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=97   =
  =E2=94=82                =E2=95=91         =E2=94=82    =E2=94=82     =
=E2=95=B2 =E2=95=B1      =E2=94=82    =E2=94=82      =E2=95=91
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=95=AC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90  =E2=94=
=82=E2=94=82  =E2=95=91         =E2=94=82  Active   V   Inactive =E2=94=
=82      =E2=95=91
=E2=94=82LINUX (kernel)   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=90=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=95=AC=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90  =E2=94=82      =E2=95=91    =
     =E2=94=82   Input         Input  =E2=94=82      =E2=95=91
=E2=94=82                 =E2=94=82system video =E2=94=82=E2=94=82    =
=E2=95=91  KVM       =E2=94=82  =E2=94=82  =E2=94=82=E2=94=82  =E2=95=91   =
      =E2=94=82    =E2=94=82              =E2=94=82    =E2=94=82      =
=E2=95=91
=E2=94=82                 =E2=94=82   driver    =E2=94=82=E2=94=82    =
=E2=95=91            =E2=94=82  =E2=94=82      =E2=95=91         =E2=94=
=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98      =E2=95=91
=E2=94=82                 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=95=AC=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98  =E2=94=82  =E2=94=82=
=E2=94=82  =E2=95=91              =E2=94=82              =E2=94=82         =
  =E2=95=91
=E2=94=82                        =E2=94=82            =E2=95=91            =
   =E2=94=82      =E2=95=91         =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90  =
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90      =E2=95=91
=E2=94=82                        =E2=94=94=E2=94=80=E2=94=80=E2=94=90      =
   =E2=95=91               =E2=94=82  =E2=94=82=E2=94=82 =E2=96=B7=E2=95=
=91         =E2=94=82          =E2=94=82  =E2=94=82          =E2=94=82     =
 =E2=95=91
=E2=94=82                           =E2=94=82         =E2=95=91            =
 see    =E2=95=B1 =E2=95=91         =E2=94=82   GPU    =E2=94=82  =E2=94=
=82/dev/null =E2=94=82      =E2=95=91
=E2=94=82                         =E2=94=8C=E2=94=80=E2=96=BC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=96=BC=E2=94=80=E2=94=90  =E2=95=B1=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80expanded =E2=95=B1  =E2=95=91         =E2=94=82          =
=E2=94=82  =E2=94=82          =E2=94=82      =E2=95=91
=E2=94=82                         =E2=94=82 soft video  =E2=94=82 =E2=95=
=B1        view      =E2=95=91         =E2=94=94=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98      =E2=95=91
=E2=94=82                         =E2=94=82   switch    =E2=94=82=E2=96=
=B7        (right)=E2=94=82=E2=94=82  =E2=95=91  =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90  =E2=95=91
=E2=94=82                         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98             =E2=94=82      =E2=95=9A=E2=95=
=90=E2=95=90=E2=95=A3    NOTE: User presses some key    =E2=95=A0=E2=95=
=90=E2=95=90=E2=95=9D
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98  =E2=94=
=82=E2=94=82     =E2=94=82       combination (example:       =E2=94=82
              =E2=94=82                  =E2=94=82                         =
     =E2=94=82 control-alt-shift-ESC) to toggle  =E2=94=82
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=96=BC=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90  =E2=94=
=82=E2=94=82     =E2=94=82  between which "OS" get's ACTIVE  =E2=94=82
=E2=94=82HARDWARE                        =E2=94=82                    =
=E2=94=82         =E2=94=82    direct GPU access while the    =E2=94=82
=E2=94=82                           =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=96=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90            =
   =E2=94=82  =E2=94=82=E2=94=82     =E2=94=82    INACTIVE "OS" is discarde=
d.    =E2=94=82
=E2=94=82                           =E2=94=82         =E2=94=82            =
   =E2=94=82         =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
=E2=94=82                           =E2=94=82   GPU   =E2=94=82            =
   =E2=94=82  =E2=94=82=E2=94=82
=E2=94=82                           =E2=94=82         =E2=94=82            =
   =E2=94=82
=E2=94=82                           =E2=94=94=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98            =
   =E2=94=82  =E2=94=82=E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
                                                         =E2=94=82=E2=94=
=82

If I'm missing any diagrammatic details, I would very much appreciate some =
correction.  Further, I'd like to discuss what could stop the development o=
f such a "soft video switch" as explained above.


Thanks for any input here!

-nuc


=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Saturday, June 1, 2019 6:07 PM, nucleare2 <nucleare2@protonmail.com> wro=
te:

> Hello, I'd like to discuss the possibility of developing a method for hot=
-swapping video cards between a KVM host and the guest machine when using p=
assthrough.
>
> It seems that currently passthrough is pretty restrictive as far as assig=
nment to the host vs guest goes. This means for applications like accelerat=
ing macOS fully a video card needs to be dedicated to passthrough for macOS=
 so that native drivers grab a hold of it at macOS guest startup.
>
> I've been thinking about the possibility of creating some kind of a dummy=
 passthrough driver that may, at some minimal level, virtualize the GPU acc=
ess so as to allow the KVM host and guest (macOS, Windows, Linux, whatever =
would need the full GPU access) to "hot-swap" access to the GPU.
>
> As I said above, right now it appears that it's necessary to have multipl=
e GPUs for the host vs guests that need/want passthrough, but if an appropr=
iate driver is developed that somehow captures some core functionality, cou=
ldn't a kernel level key combination capture be implemented that would flip=
 passthrough between host and guest(s)?
>
> Basically if a macOS or Windows (or Linux) guest BELIEVES it still has co=
ntrol of the GPU, then the guest kernel should not panic and should still r=
emain operational while the host get's access. I'm not talking about any ki=
nd of capturing here, just simply making the host or guest think it's still=
 getting GPU access and happily spinning away while the user is flipping be=
tween host/guest instances.
>
> Has anyone considered this or put any work into this so far?
>
> I've seen someone else mention this before somewhere, but it seemed to no=
t get any attention. This is a pretty critical function that would benefit =
KVM users enormously.
>
> -nuc


