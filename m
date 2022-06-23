Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD8455722F
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 06:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiFWEqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 00:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243621AbiFWDu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 23:50:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4B63DA6B;
        Wed, 22 Jun 2022 20:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655956226; x=1687492226;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6B2s3eiJcq2UuiOsg+t4I+Qr1fX6UpaNzSb6WwASJr4=;
  b=VDj/sBFM7GYRbxOMxAEXVjLkWRMdF6F8CyV2nCTRveCeHyh/tRrf7oiU
   XSrRmsQHT7eHnfeP27PY9uq20mEcRRjtyEMWN/1a4POB9NrW4eHzm92S3
   PC+KYczNy5imWa+cXsJ5cH7zmaMVun1xNxP9hKIXaUEvrvAUbZ7mlS3am
   hB7FMDHXIKOAtdGt1l4fJ0QKdRKMERFVoKeMpVoFHPQoQOFPkIQhrrKmc
   cWb8buK5gN4t4vYMA5udW+zJcplm6p7eggyWdVY7LEnFe9Ztb1Ho0LrZL
   cYeMpOCNf50KYoFLMHl7zEEwbKQPyg9KQsJJU8CS1zT433FAgtH+c4X/V
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="344605703"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="344605703"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 20:50:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="690830804"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2022 20:50:25 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 22 Jun 2022 20:50:25 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 22 Jun 2022 20:50:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 22 Jun 2022 20:50:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 22 Jun 2022 20:50:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhLUm/MHhxnFDMQAJlCklRA28DizmslhBHE8BnYsmetM84DJMi9sgWbW0CrxZlXu6BRhvbJFyUnk5jLPVm03GhOcvoMBA2EtP0f4y9Ya2xf+H6HaQbnRTY3Lu2nBsZGrqUiuehSXG6bwtM587WU4n6Hew36rR/YVpCLoaDhRVaC6td7RTZq3PrmTyJ9ecff2gZoIQn5UjjI/OCFfEQAJl3jDUo8ruLllRchqfObKrGLVv02BKSUMk9S0hhGiyqFegmrh5JgdRbvVJPVgeg2lGFk32XqDDPYm+laCF9ed6oHboxD3L19t8dsjeBsT+xQK5E4JZyaW0Oixd2fxwbm3Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6B2s3eiJcq2UuiOsg+t4I+Qr1fX6UpaNzSb6WwASJr4=;
 b=PDzmPtwxqEF7maaAAnNLeDbKNLw3Y7zc2y248Rqachb/fzqWRPD6aGs5t/uwDd8dI85Aop+5RNImEpfkg1uVpaXyT1HVIPfUGOi8FPfM6nQbhp5kyD7heNOLvKRkcB9toeNc0gerbVSeVelnu7ElaLse+X/UAdGmtbvVHmG0ycl1nRwq0HHzXBVnW8PYzOiGuxZSnHz39c6Vd/h5+PO6JE49oOP7ofPzG5amsNRgo/1hdF5VhU1e5M+5SVUTvXBPjDgEvN5i2GLjToxVReww7sXEY/qXVmBNWatuVAwNhtP7utNPccfZYm8GxuNIaE+1+S01tH49Njks2RXq/DL1iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB1789.namprd11.prod.outlook.com (2603:10b6:300:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 23 Jun
 2022 03:50:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 03:50:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "saiprakash.ranjan@codeaurora.org" <saiprakash.ranjan@codeaurora.org>,
        "isaacm@codeaurora.org" <isaacm@codeaurora.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Thread-Topic: [PATCH v2 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Thread-Index: AQHYgRSGh5VNWlGZFU2izdpXwolvG61RkriwgAEKiACACHtDgIABTdzA
Date:   Thu, 23 Jun 2022 03:50:22 +0000
Message-ID: <BN9PR11MB52760486306A90A208D7C6768CB59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-4-nicolinc@nvidia.com>
 <BL1PR11MB52717050DBDE29A81637BBFA8CAC9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <YqutYjgtFOTXCF0+@Asurada-Nvidia>
 <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
In-Reply-To: <6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2c69472-df97-4928-41dc-08da54cb7fae
x-ms-traffictypediagnostic: MWHPR11MB1789:EE_
x-microsoft-antispam-prvs: <MWHPR11MB178942E9BBE00505CDFA76628CB59@MWHPR11MB1789.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WoQZYUUotR/D6P93GhUaYds6axe3LjEnE1+1GqNCefO/RswXyPHWjV5cPTPIWRdybKegY+rNtKsbNWhf7FyN1BTI43iGZ6zOKNxIf0+5oASNzZJZUm2NQPFr7m2fpoud+fRQuNZ+fhFpjEtggtmwcQHss9/bzWyjP18Df5TuUeb7lRnog6yJHOmQg7mxvKvi+OxyXhjEPyfmkcaUoFxtoffmF7zERuUAeinuXQSY0aMmxkoCTgiymYSwunX4P1J+F3My8n2Xmef5fahse+CwJuv72Ci8f8YVZxPsgWFukcU/lNmh1NNSBr/ZGnBnbmHAdRO3PiYvydNUrVl1LEi12HWv7PIQ3xNKHpMCLa1gFRy3o0LI920+jfzTdCOdo+oIAOdSyKnY+gbylYTkRLM7hWQPnybsvDyPR4d2G8mfKLucHHnGL7CLGXGEhtOMiD5NVaQrTQ4oXRzUC8lUZCltel2DGNA2FW2P9OJnx9oTSCN5cHXjIMkdAaL+JgCmOrOMpLhU9diqmAnqGhEOwNPj83w6xKmAD8Ha7RSYptK8RRiXg9Qy8WL0pZd/bgy6iGiF9ew8gtjpg2seKjxnxLqmuB4iuu2L2Ndle8mItnYTOcfVTem0y5+N1eabLF1eDHaBFYaDb2++O1X1loqAnSur4PcLNBYVsjbr4hnH2s5x2MIVcK/HIV0NasYjODiM6sXx0juTvXU3Dxxc23U9dUJjzkrFWzV6ekClGI3lpysMIjRjAVHJuvnBkHfa5sIDTc+F57q1clTUDeZCjn9o/A7Pzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(396003)(366004)(136003)(41300700001)(316002)(76116006)(38100700002)(55016003)(33656002)(186003)(2906002)(110136005)(38070700005)(8676002)(8936002)(66476007)(4326008)(54906003)(71200400001)(66946007)(5660300002)(66446008)(66556008)(478600001)(122000001)(9686003)(6506007)(82960400001)(7406005)(64756008)(26005)(86362001)(7416002)(52536014)(53546011)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWVWbm5mdzN4L2orQTUyZDN3Q2VWeUNkNVJKV0JiaE5lcURxbFdIMzNFcG1m?=
 =?utf-8?B?d1pjYStmK2pTTWJiUllVVmVNYUtTRDNzeXByV3RCaHY4YVNZUG5ZOS9UU2NI?=
 =?utf-8?B?WE05MmVyL3czZWZZVW5NR2NQNXVJNHhjcGFRdlhTZzIxZUlUdTVDNWRLWTJF?=
 =?utf-8?B?ZFhNWXNGN05XQXlFdUM3cUdYd0ZWVzNxVHMvRGg0d1A4My8zb3FSUzF6MFpN?=
 =?utf-8?B?eStya3ZxWS9Ib3VWNWJwaDl3RjZDT2JVYi84YnljZm5uV1hXSHNvV0Z1ZDdi?=
 =?utf-8?B?a0tZYk5oWkVWa0FmQ3ZMMGk3RWZDOFE0dDlBVmdkeTB0WW1hZzNuREFjWUlq?=
 =?utf-8?B?N3BDUy9HTy9UTXpiU1UwZll1SGpySTBRUkhnb0E3MDBoUW4xOFFEdi95aUV1?=
 =?utf-8?B?bk03bE5iNkY3Q2Y1cldCbkozR1k3MGJ0MkdMb3d2SE04VHhManloSlBhc0Jq?=
 =?utf-8?B?alJ0Y1RzeXJmaG1KaXNtMmxBejkwdTFLNk4ybjZMRCt3WTdZNEorMVdSeU5B?=
 =?utf-8?B?RTYrVjBrT25XZ21JdlNZMFErVHNHVkhhT1JucFJUcGlwM1R0S3dGK0Q1WDcv?=
 =?utf-8?B?cENrMHhUMVZyMnVMSUE4eThPcGFyd252YjBSUWZvYjBJTFNldjIwUjF6ZG9k?=
 =?utf-8?B?dHQ5MGhFZXRvSy9qSDJOTS9KV3VNcHJMMzB2YlRNTUlxeTZEM0pOcW53TjNR?=
 =?utf-8?B?U3Zhc042NkYxKzg0aE9HMDFaTmN2SXZINTVNL3lDN29ML205bW1qd0xYTDM4?=
 =?utf-8?B?d044TzlvK0Z4V3p3Z0Fhd09NTkV1SVl3dzVremRxcmUyVXNkY2d3ZExKRFdq?=
 =?utf-8?B?OGxRSlg2cjl3SkVpQll4NDJQMnowcFpCdlhSOGxNaVVVMGdPeGZBb2RPamVM?=
 =?utf-8?B?K3pyVUE4MUNIdlNjWEl2Wk9OeDBsMThueGVVaUxaNWNEWXZUUGxZbUtBbklZ?=
 =?utf-8?B?ckFUTUpaWnVQMy80ZjhwbVU3aUJxZFFkYmduKzJEMlluU3dNcG43eHZBcW50?=
 =?utf-8?B?RmkvRW05bjVHWGhRNnZQRW9jWm9hbDBKSFBQU3BhWkNGZ2hTY2JxeEdkTVJH?=
 =?utf-8?B?NkdnYXhDT1VlczBiaEpUTUovRmRMVGJ4c2tYV1ROMklJS05Va0hIT0UxUmUr?=
 =?utf-8?B?a0FPSHY0QmxnZDNXNVhyVGVybi9zSlBPOUxyMk1ZZ1Q0UzV2S25TVkdjdFky?=
 =?utf-8?B?NE4rb2FMZVVBZ0tUd0lLdGZoZmNlVFUvakI1blJLb2tzMnRSYTJ0NVJVQ2R0?=
 =?utf-8?B?MDd2cDkwZ2ZMdWFhMWpSZ2ZVaXVSU1B5dWtHSXdyL0xuSW5LUURaWUhpNmIw?=
 =?utf-8?B?RTh3THFUUmEzanFhTGY3WnN1b3U2UmxjNWFxZHZyQ3J5eGUzUlQ5SlJmdE1r?=
 =?utf-8?B?NnVmYVVmaG0zRWI0ZSt6dUJjRlUxblJFbVl0T2dlalZ1Nkx5MjhRVDJWa0RX?=
 =?utf-8?B?NzFMNHZGZ21nME82WVNzdW8yWkVFRHE5Nld3K3dmSHd0emZpQzZzSmVxdzFy?=
 =?utf-8?B?RlhHdm1TUlVjZHVuOW1xbjBuQmxKYkJLQ2ltc1AwSmtSYmZsVUxGVVlTQmJY?=
 =?utf-8?B?cXR2dFhRVHpac2h6RFc5cDRIUWZEc3NnWm1wamtjbUlHY0VheTZxcWpzeVpB?=
 =?utf-8?B?Ui8yTm5OOW5XVmxneTVQbUZkQjdERE1MZEFTZkNVK1kxUGxEcmFmdlp3R0hQ?=
 =?utf-8?B?QU5ZalRNSWN2OVgvcmd3Qm5FdThSRXdTaVhqQlJ1Q3NBVVltQzE5TWRpdnhB?=
 =?utf-8?B?Y1RoYmhmeENpNWlrZzZRdThWanFFbmwzSlNyYm4rNE9xZklpcnNvWDdNZXk0?=
 =?utf-8?B?Q3RZYTZxem5NdnFhMm0zTzNDeC9TZUZlaE9ERDVHY05BclJNaFJ1WUcyYllF?=
 =?utf-8?B?bGxRaWFVYUJMNXJzTmhISkRwd2VnU0FQQ1NlVHVpVXBxdE5EdDlHTmJOclJW?=
 =?utf-8?B?d2tUSUR0NE1oUkFWZzFMYjdCUURRcm5YNmNJUmVjdVhNR3BZT0d5eDYvTm1N?=
 =?utf-8?B?QjFxWHo5MGh4SG93WnBiZ2tiaGhzVEtkMk8xVk9sRkJlZmcvazZ3cngrakti?=
 =?utf-8?B?NjZ2UFlxWHpSOGFJb215TktRT1BUbGZ3ZzhZcmduWTB0bmVYRUZKVUtvcGg3?=
 =?utf-8?B?ZG0yQ0MvcVorUEJ5d1lLdnk5Ylp2cjdtbzNpSWxLWENIOVhOR2tJNWk4ZHMx?=
 =?utf-8?B?QUIyK1RsellvN0dqTUR2REg4aWtDMThVQWxKeWo3dERvVU8rNGMwL05ISjFG?=
 =?utf-8?B?eThvOXkvRUt2WDc0MXA3c01QNWt1eUhqU01ERDBWU2hvbEVsdy9nM3NFVW9k?=
 =?utf-8?B?eDBVTUY5MStORnA0WUttUjlXVSs4OGh3Sk1zM3JiMzRHYWpsa05odz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c69472-df97-4928-41dc-08da54cb7fae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 03:50:22.3254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35LwvEPbjoIonQS7JREzFUFJyNMzXud4rrkr+5iQpmMAP2m+wZIlfNSYTxIa2WSCpOu8md1PuEvInQlkv/8ORA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1789
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBSb2JpbiBNdXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIEp1bmUgMjIsIDIwMjIgMzo1NSBQTQ0KPiANCj4gT24gMjAyMi0wNi0xNiAyMzoyMywg
Tmljb2xpbiBDaGVuIHdyb3RlOg0KPiA+IE9uIFRodSwgSnVuIDE2LCAyMDIyIGF0IDA2OjQwOjE0
QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+DQo+ID4+PiBUaGUgZG9tYWluLT5vcHMg
dmFsaWRhdGlvbiB3YXMgYWRkZWQsIGFzIGEgcHJlY2F1dGlvbiwgZm9yIG1peGVkLQ0KPiBkcml2
ZXINCj4gPj4+IHN5c3RlbXMuIEhvd2V2ZXIsIGF0IHRoaXMgbW9tZW50IG9ubHkgb25lIGlvbW11
IGRyaXZlciBpcyBwb3NzaWJsZS4gU28NCj4gPj4+IHJlbW92ZSBpdC4NCj4gPj4NCj4gPj4gSXQn
cyB0cnVlIG9uIGEgcGh5c2ljYWwgcGxhdGZvcm0uIEJ1dCBJJ20gbm90IHN1cmUgd2hldGhlciBh
IHZpcnR1YWwNCj4gcGxhdGZvcm0NCj4gPj4gaXMgYWxsb3dlZCB0byBpbmNsdWRlIG11bHRpcGxl
IGUuZy4gb25lIHZpcnRpby1pb21tdSBhbG9uZ3NpZGUgYSB2aXJ0dWFsIFZULQ0KPiBkDQo+ID4+
IG9yIGEgdmlydHVhbCBzbW11LiBJdCBtaWdodCBiZSBjbGVhcmVyIHRvIGNsYWltIHRoYXQgKGFz
IFJvYmluIHBvaW50ZWQgb3V0KQ0KPiA+PiB0aGVyZSBpcyBwbGVudHkgbW9yZSBzaWduaWZpY2Fu
dCBwcm9ibGVtcyB0aGFuIHRoaXMgdG8gc29sdmUgaW5zdGVhZCBvZg0KPiBzaW1wbHkNCj4gPj4g
c2F5aW5nIHRoYXQgb25seSBvbmUgaW9tbXUgZHJpdmVyIGlzIHBvc3NpYmxlIGlmIHdlIGRvbid0
IGhhdmUgZXhwbGljaXQNCj4gY29kZQ0KPiA+PiB0byByZWplY3Qgc3VjaCBjb25maWd1cmF0aW9u
LiDwn5iKDQo+ID4NCj4gPiBXaWxsIGVkaXQgdGhpcyBwYXJ0LiBUaGFua3MhDQo+IA0KPiBPaCwg
cGh5c2ljYWwgcGxhdGZvcm1zIHdpdGggbWl4ZWQgSU9NTVVzIGRlZmluaXRlbHkgZXhpc3QgYWxy
ZWFkeS4gVGhlDQo+IG1haW4gcG9pbnQgaXMgdGhhdCB3aGlsZSBidXNfc2V0X2lvbW11IHN0aWxs
IGV4aXN0cywgdGhlIGNvcmUgY29kZQ0KPiBlZmZlY3RpdmVseSAqZG9lcyogcHJldmVudCBtdWx0
aXBsZSBkcml2ZXJzIGZyb20gcmVnaXN0ZXJpbmcgLSBldmVuIGluDQo+IGVtdWxhdGVkIGNhc2Vz
IGxpa2UgdGhlIGV4YW1wbGUgYWJvdmUsIHZpcnRpby1pb21tdSBhbmQgVlQtZCB3b3VsZCBib3Ro
DQo+IHRyeSB0byBidXNfc2V0X2lvbW11KCZwY2lfYnVzX3R5cGUpLCBhbmQgb25lIG9mIHRoZW0g
d2lsbCBsb3NlLiBUaGUNCj4gYXNwZWN0IHdoaWNoIG1pZ2h0IHdhcnJhbnQgY2xhcmlmaWNhdGlv
biBpcyB0aGF0IHRoZXJlJ3Mgbm8gY29tYmluYXRpb24NCj4gb2Ygc3VwcG9ydGVkIGRyaXZlcnMg
d2hpY2ggY2xhaW0gbm9uLW92ZXJsYXBwaW5nIGJ1c2VzICphbmQqIGNvdWxkDQo+IGFwcGVhciBp
biB0aGUgc2FtZSBzeXN0ZW0gLSBldmVuIGlmIHlvdSB0cmllZCB0byBjb250cml2ZSBzb21ldGhp
bmcgYnkNCj4gZW11bGF0aW5nLCBzYXksIFZULWQgKFBDSSkgYWxvbmdzaWRlIHJvY2tjaGlwLWlv
bW11IChwbGF0Zm9ybSksIHlvdQ0KPiBjb3VsZCBzdGlsbCBvbmx5IGRlc2NyaWJlIG9uZSBvciB0
aGUgb3RoZXIgZHVlIHRvIEFDUEkgdnMuIERldmljZXRyZWUuDQo+IA0KDQpUaGlzIGV4cGxhbmF0
aW9uIGlzIG11Y2ggY2xlYXJlciEgdGhhbmtzLg0K
