Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8146EB76A
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 06:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjDVEvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 00:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVEve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 00:51:34 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55251BE4
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 21:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682139093; x=1713675093;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=0+BM5+OJMsCgwISioqzSGipFr4klidYV1ezhaX49bvc=;
  b=nBcNoqBAj+fWwg7yTRnW4NnpsmWjKpCwzXvMjbYIQ3PIiOP8VRmKGZ49
   mlN7hI2X6QyNXZUNnfElDIfbS5EaKu59AjPGK1De2bKEFErWPqH3PAXwR
   SGTBREpg8UOqQVpH71z4Ltw7dzYDIcf2GBy1Z3eMAtjRs+ZOSTRimeekS
   xqMYaunTCQvgZ2eK/Snqq/PNLJjtkQIULfDYBKx7mcUyjp/CgsXKVE8q0
   bmLgTc7VmNgusGhyJROavjqFG2uAey28ngtbkSsZyT0rFjD+JDtt95rOX
   CC1k/5deeKVNIkzdbqKEF4SxiddYHYAYVEaN1tbhVFRqH1mMQO+lirDR6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="348038530"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="348038530"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 21:51:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="669916335"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="669916335"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2023 21:51:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 21:51:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 21:51:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 21:51:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 21:51:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajFiHzgFw3vmvxMrd3gQYZVOwggu2zWgnus5OUJgrbudbd5hycTu6oiZ7kaSpXfPSz32siEh34gnxzUspTFosK7TblcN2Rg+EG9PwsPG5px23QKpNy3iQm4RVtH+h0dL1qMVNHAYm1CoZdAUlhh1cIbSbl/Mj7/YDTkVjbaOLRvRofxxx4jFGpKLa4ndfIKNa5LVV8EFi6hBfg5rae6YZRVmMHf0BhdMX9uN0jwxp1/ewe6vWpRXatq/MN8ABq+/+/BfBiQR9vV8IqtOnh0ZMajfgoUfJ1+r+p2uJzXPllqwoywxQJSWYLXieaOXbrYqXI2V8WixTkuigFn/0/VErg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gvDLhgbp6LG5gNyhJS4FrqCnqBuQt47Afo7CDhaiEU=;
 b=XMAtLE08dqr8DJejlL2j7XgZzAXrns5ixX8HkDwyDNN9ZB/yGRP3IhGyevhSzJhmrt0+CfPpD5pwcrmnbcR0S0R06yYmgT8nTG0gnt71WLvwlYnByY1R+qmE/7rX8N70ZL9NsdG9efyWsrejre77rWi+10uwQhkitWfiYq0Y3GQ8WXNzSpXSIGfzolFmDwg2uW1kFmvbtsIozJQgnJOkO+BVcIkNMiQcbTDVy4yHZK6HP3ftgwQwWOQvzsWEY1s6uZ1MMljpRQrrpPvMdfp0BxWPmID8cIxC2r1PlRJhm5d3UR3Grx+C0QhXFq/ihXKxmi/UWjrNk+WP9WRlGT3PtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS0PR11MB8206.namprd11.prod.outlook.com (2603:10b6:8:166::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Sat, 22 Apr
 2023 04:51:25 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.029; Sat, 22 Apr 2023
 04:51:25 +0000
Date:   Sat, 22 Apr 2023 12:51:14 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Message-ID: <ZENnwtBzRVz14eS+@chao-email>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <9c99eceaddccbcd72c5108f72609d0f995a0606c.camel@intel.com>
 <497514ed-db46-16b9-ca66-04985a687f2b@linux.intel.com>
 <7b296e6686bba77f81d1d8c9eaceb84bd0ef0338.camel@intel.com>
 <cc265df1-d4fc-0eb7-f6e8-494e98ece2d9@linux.intel.com>
 <BL1PR11MB5978D1FA3B572A119F5EF3A9F7989@BL1PR11MB5978.namprd11.prod.outlook.com>
 <5e229834-3e55-a580-d9f6-a5ffe971c567@linux.intel.com>
 <7895c517a84300f903cb04fbf2f05c4b8e518c91.camel@intel.com>
 <ZEKsgceQo6MEWbB5@chao-email>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEKsgceQo6MEWbB5@chao-email>
X-ClientProxiedBy: SG2PR04CA0161.apcprd04.prod.outlook.com (2603:1096:4::23)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS0PR11MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abe5e60-bef1-44ca-4122-08db42ed39d7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAO28j9KQ87nCUcmL9l7hev+Qwt0xmJ9Ox705JSzVxY8n76EgrbI3mQDrIvUtwlwEek0rL+ehcFFS5niPLoQYyDPH8mlFEmsl+03w9YmEglZNH6xxG/QufQAIx13AFKHyEFLr8ADdHAHXbcIkQY3XOIItEMixuETt4lVCvZL3JneuiP3XkKKR86lMsnkCgvFzsi1og8HRA4sCBsNsdR52Ywnp6JI+TYxPL7pcf/BpWBWybXNWQ5EfpDD9F+TAObUK3xnnvW1sg0zAvrYx8k3yXveuif9NI1s/O9NWdIvHwJFhvwm61dRBjppCvI2qshJ4ZoP2l90irn9w4xvlmHxH77KUFvlvKHOGVH2Wim3UWg49g3iHYNkZrvGrJEC8NEKX0LRWAAeIDHk2sQy0OW72jQDQW38Hb/3H7IxdMNND3FwnP5upmenyKssInswQutWQKSLy7ucLcdhRLJjXHI/0detUIdjGWK4HlfnlI/l6guiScp98o0RolNUlN8bPj+3bRYw2g2qKkLS96dsnB005+evAaOOV9dypyQM3KjdxtoE7Q//Z6091/rqLHLgO5Ya
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(54906003)(316002)(66556008)(66476007)(66946007)(6636002)(4326008)(186003)(6506007)(6512007)(83380400001)(38100700002)(26005)(9686003)(41300700001)(8676002)(6666004)(6862004)(33716001)(8936002)(5660300002)(6486002)(478600001)(2906002)(86362001)(4744005)(82960400001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?xg3Rl5pcxZqn2eWj+WUgOGE1f+f5iJq63KgphX3cWiUcR+YATnDNxnefzU?=
 =?iso-8859-1?Q?u2UaSvt2LL7Y2awvfx59nSgZZyjTHPMwctcj5vaTX0aGOIwdeHB0LnUpzc?=
 =?iso-8859-1?Q?duxsBlXNakp0WmI5eE2uXtjOagVA+tS/HVCg/lJJngv0b8j3kGrykKPtyu?=
 =?iso-8859-1?Q?f8Fi65fTyP/z+SctnZpXHxC8wkMSgQu/jiwPPTKiMvyMMDzcCro85VVt1T?=
 =?iso-8859-1?Q?2lKHD23zFgiDE0o00IcF7GnN/NNlT0RTZyjKiJYF8A2DSswBDgLxeIs4lE?=
 =?iso-8859-1?Q?TpPsSWTg4a3Ao0rParwKs3c/Nd6tU60/peQklHNHvfCb+6kuw5zqiUZzX3?=
 =?iso-8859-1?Q?vJPT9jMOFrdVMijxpW7magkrf/MSWwP2uMXha4adqaKkvLQu8LwxlN+TuV?=
 =?iso-8859-1?Q?zrtVST99ioGIhyiPSEgqYVRg4CNwvuJWnm5Rdwrezp9bXaysQIKd/9vkZ+?=
 =?iso-8859-1?Q?3KvzD4oMz0lbRoaifloNj8BwstoG6SxNuMPRQIYcA7zeJB2bf75iH2La/I?=
 =?iso-8859-1?Q?m861npA5/iR2tcUeNiHjGBOiT3ZfuiRHal0RfUOG0wKecDVA+XYgCo+POA?=
 =?iso-8859-1?Q?5NXr2Zp3M5fkDgXBBXzxMQ6pPtHh9Tj2Qktye1+f1yhrxA61jVUyT/CDWh?=
 =?iso-8859-1?Q?YcZknZ6fnQMiH7RVSct08053Ho3x2x1/68Wkhr9MZ5YNhpDHK+mMkRVVjA?=
 =?iso-8859-1?Q?35eplYcAxjrpXdqyoXmJOjvNmKP6KJDbj8NOQT/GIGS95JhxuMi6S+VIRX?=
 =?iso-8859-1?Q?OM2TKINSPQtzcAxR3jwpSvB2ZW4YOXgHQ5VwlVtpwsyxhiniEN9owW6KWs?=
 =?iso-8859-1?Q?wncJj8QEefR5VdXZ8Ja6vBoc0A52NpGnGpZb7I6UAO1MtBJDrx3pDRGwMY?=
 =?iso-8859-1?Q?CJmbF5puW3zI5NWIZu/oIz6OYA6oF29mrXEeCZX4o28zdCuvT6YTDUvgLN?=
 =?iso-8859-1?Q?DRGjnzTFvWEM7NQMES44yaeOHSoFLppq/ggTJdj87t7EU9x0+Cptzo/AIP?=
 =?iso-8859-1?Q?MXdNIWfAJc3FtH08oQuHrbsQN2VRQDG1IkUniSlmXj0zA+EDI6c34R/Gzv?=
 =?iso-8859-1?Q?rORnS27SIHebUMeJzdHVZ6jLQb1yImVjClHobZm2jf/u5Vs5l5LUg/tm2v?=
 =?iso-8859-1?Q?PZuNriRNi5eOhMMB1fO9NQhjG+C9Vtd4MOHYs+O+4wrLHbZtGg60pCwIjY?=
 =?iso-8859-1?Q?PhkISbvLVjkWz1mNI70Vxyoib+xFADOqJFNeA6IGH3PRVi9rjzHTn14Zgk?=
 =?iso-8859-1?Q?EeceTIuV2sIhs5SWFIr8jhJjaRxjBAh5d/CF7urPYfOOR1/tu9HxVl45Vf?=
 =?iso-8859-1?Q?okI2ASRYdj+IDPe4hGrZC8t1eKAEXxSVb3ztthXrdXOJ3OA94l0kNGmVqY?=
 =?iso-8859-1?Q?v9mSRE2K9FiJQVb/iH78UgX6Cv2pCaO+LG16TNdxVWdbxQr3TrZ27z+Z61?=
 =?iso-8859-1?Q?Vt32ZSkfVr9rA57w1n1sJLo9MNalETQ+ljI3YRmwqKkH1+DUtJ5yw5eAyG?=
 =?iso-8859-1?Q?suJpNbvZfX4bZDrOueoL/RtRR2drkuqQf8E2UUf2yqqHLBH0ici4eWk705?=
 =?iso-8859-1?Q?hg/FrszFCS72FL3Xs1gXBjJifbmVg+dd2WXWF84U+ZTjEhxx4Vmimd+tZR?=
 =?iso-8859-1?Q?1KGf/LTDIwgAruYWJUfAym+6yLXrKz48JO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abe5e60-bef1-44ca-4122-08db42ed39d7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 04:51:25.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGNIbSelA6SUGzqd2HYrBmcfYwgVy2ZqHaPI0Ps/r3XFi1ZRKLGzc2FM9UvJusRJ2mYfoxSvF4wR+ln5A4F25w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8206
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 11:32:17PM +0800, Chao Gao wrote:
>>For case 2) I _think_ we need new code to check both VMCS12's HOST_CR3 and
>>GUEST_CR3 against active control bits.  The key code path is 
>
>...
>
>>
>>	nested_vmx_run() -> 
>>		-> nested_vmx_check_host_state()
>>		-> nested_vmx_enter_non_root_mode()
>>			-> prepare_vmcs02_early()
>>			-> prepare_vmcs02()
>>
>>Since nested_vmx_load_cr3() is used in both VMENTER using VMCS12's HOST_CR3
>>(VMEXIT to L1) and GUEST_CR3 (VMENTER to L2), and it currently already checks
>>kvm_vcpu_is_illegal_gpa(vcpu, cr3), changing it to additionally check guest CR3
>>active control bits seems just enough.
>
>IMO, current KVM relies on hardware to do consistency check on the GUEST_CR3
>during VM entry.

Please disregard my remark on the consistency check on GUEST_CR3. I just took
a closer look at the code. It is indeed done by KVM in nested_vmx_load_cr3().
Sorry for the noise.
